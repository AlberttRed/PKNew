class_name BattleMove

signal updateHP
signal actionSelected
signal playAnimation

var instance : MoveInstance

var pokemon : BattlePokemon # Indica a quin pokemon pertany 

var id : int
var Name : String
var type : Type

var power : int
var accuracy : int
var priority : int

var pp_total : int
var pp_actual : int

var critical : bool = false

var min_hits : int
var max_hits : int
var num_hits : int
var statChangeMod : Array[CONST.STATS]
var statChangeValue : Array[int]
var ailmentType : CONST.AILMENTS
var ailmentChance : int :
	get:
		if ailmentType != CONST.AILMENTS.NONE and ailmentChance == 0:
			return 100
		return ailmentChance
			

var target : CONST.TARGETS
var move_effect : CONST.MOVE_EFFECTS
var category : CONST.MOVE_CATEGORIES

var damage_class : CONST.DAMAGE_CLASS
var contact_flag : bool = false

var effect : BattleMoveEffect
var animation : BattleMoveAnimation

func _init(_move : MoveInstance, _pokemon : BattlePokemon):
	instance = _move
	id = _move.id
	Name = _move.Name
	type = _move.type
	power = _move.power
	accuracy = _move.accuracy
	priority = _move.priority
	pp_total = _move.pp
	pp_actual = _move.pp_actual
	target = _move.base.target_id
	move_effect = _move.base.move_effect
	category = _move.base.meta_category_id
	damage_class = _move.damage_class as CONST.DAMAGE_CLASS
	contact_flag = _move.base.contact_flag
	min_hits = _move.base.meta_min_hits
	max_hits = _move.base.meta_max_hits
	statChangeMod = _move.base.stat_change_ids as Array[CONST.STATS]
	statChangeValue = _move.base.stat_change_valors
	ailmentType = _move.base.meta_ailment_id
	ailmentChance = _move.base.meta_ailment_chance
	
	pokemon = _pokemon	
	
	effect = BattleMoveEffects.new().getMoveEffect(self)
	var n = instance.internalName.to_upper()
	#if FileAccess.file_exists("res://Animaciones/Batalla/Moves/Classes/" + str(n) + ".gd") != null:
		#animation = preload("res://Animaciones/Batalla/Moves/Classes/TACKLE.gd").new(self)
	#else:
		#animation = BattleAnimationList.new().getMoveAnimation(self)
	

func use(to: Array[BattleSpot]):
	
	num_hits = getHits()
	
	#await pokemon.applyPreviousEffects()
	
	await GUI.battle.msgBox.showMoveMessage(pokemon, self)
	
	for i in range(num_hits):

		await effect.doEffect(to)

	#await pokemon.applyLaterEffects()
		
func doAnimation(target):
	var animParams:Dictionary = {'Target':target}
	playAnimation.emit(instance.internalName.to_upper(), animParams)
	await SIGNALS.ANIMATION.finished_animation
	#await animation.doAnimation(target)
	
func is_physic_category():
	return damage_class == CONST.DAMAGE_CLASS.FISICO

func is_special_category():
	return damage_class == CONST.DAMAGE_CLASS.ESPECIAL
	
func is_status_category():
	return damage_class == CONST.DAMAGE_CLASS.ESTADO
	
func calculateSTAB(target : BattlePokemon) -> float:
	var STAB_type1 : float = 1.0
	var STAB_type2 : float = 1.0
	
	STAB_type1 = type.get_effectiveness_against(target.types[0])
#	print(type.Name + " against " + target.types[0].Name)
#	print("STAB1 " + str(STAB_type1))
	if target.types[1] != null:
#		print(type.Name + " against " + target.types[1].Name)
		STAB_type2 = type.get_effectiveness_against(target.types[1])
#		print("STAB2 " + str(STAB_type2))
		
	print("total STAB1(" + str(STAB_type1) + ") * STAB2(" + str(STAB_type2) + ") = " + str(float(STAB_type1) * float(STAB_type2)))
	return float(STAB_type1) * float(STAB_type2)
	
func calculateDamage(to : BattlePokemon,r = null):
	var Damage : int
	#var Modifier
	var Att : float = pokemon.getModStat(CONST.STATS.ATA) # pokemon.attack
	var Def : float = to.getModStat(CONST.STATS.DEF) #to.defense
	var STAB : float = 1.0
	var Ef : float = calculateSTAB(to)
	var random : float
	var Targets : float = 1.0
	var Weather : float = 1.0
	var Critical : float = 1.0 # TO DO
	var Burn : float = 1.0
	var Other : float = 1.0
	
	if is_special_category():
		Att = to.getModStat(CONST.STATS.ATAESP) #pokemon.sp_attack
		Def = to.getModStat(CONST.STATS.DEFESP) #to.sp_defense

	if has_multiple_targets() and pokemon.listEnemies.size() > 1 :
		Targets = 0.75

	if GUI.battle.controller.activeWeather == CONST.WEATHER.LLUVIOSO:
		if type.id == CONST.TYPES.FUEGO:
			Weather = 0.5
		elif type.id == CONST.TYPES.AGUA:
			Weather = 1.5
	elif GUI.battle.controller.activeWeather == CONST.WEATHER.SOLEADO:
		if type.id == CONST.TYPES.FUEGO:
			Weather = 1.5
		elif type.id == CONST.TYPES.AGUA:
			Weather = 0.5

	if pokemon.types.has(type) and pokemon.hasWorkingAbility(CONST.ABILITIES.ADAPTABLE):
		STAB = 2
	elif pokemon.types.has(type) and !pokemon.hasWorkingAbility(CONST.ABILITIES.ADAPTABLE):
		STAB = 1.5

	if pokemon.status == CONST.STATUS.BURNT and !pokemon.hasWorkingAbility(CONST.ABILITIES.AGALLAS) and (!is_special_category() and move_effect == CONST.MOVE_EFFECTS.IMAGEN):
		Burn = 0.5

#	if to.types[1] != null:
#		Ef = Ef * type.get_effectiveness_against(to.types[1])

	if r == null:
		randomize()
		random = randf_range(0.85, 1.0)
		print("random " + str(random))
	else:
		random = r

	Other = calculate_others(to,Ef,false)

	Damage = int(int((int((2.0 * float(pokemon.level))/5.0 + 2.0) * float(power) * float(Att))/float(Def))/50.0 + 2.0) #(((2 * from.level/5 + 2) * power * Att/Def)/50 + 2)
	print("Level: " + str(pokemon.level) + ", Power: " + str(power) + ", Attack: " + str(Att) + ", Def: " + str(Def))
	print("Damage: " + str(Damage))
	print("Targets: " + str(Targets) + ", Weather: " + str(Weather) + ", Critical: " + str(Critical) + ", Random: " + str(random) + ", STAB: " + str(STAB) + ", Ef: " + str(Ef) + ", Burn: " + str(Burn) + ", Other: " + str(Other))
	var result = int(int(int(int(int(int(int(int(Damage*Targets) * Weather) * Critical) * random) * STAB) * Ef) * Burn) * Other)

	if result == 0:
		result = 1
	return result
	
func calculate_others(to,Type,critical):
	var value = 1.0

	### MOVES
	if to.side.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5
		
	if (move_effect == CONST.MOVE_EFFECTS.GOLPE_CUERPO or move_effect == CONST.MOVE_EFFECTS.CARGA_DRAGON or self.move_effect == CONST.MOVE_EFFECTS.CUERPO_PESADO or self.move_effect == CONST.MOVE_EFFECTS.PLANCHA_VOLADORA or self.move_effect == CONST.MOVE_EFFECTS.GOLPE_CALOR or self.move_effect == CONST.MOVE_EFFECTS.PISOTON) and to.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.REDUCCION):
		value *= 2.0
		
	if (move_effect == CONST.MOVE_EFFECTS.TERREMOTO or move_effect == CONST.MOVE_EFFECTS.MAGNITUD) and to.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.EXCAVAR):
		value *= 2.0

	if (move_effect == CONST.MOVE_EFFECTS.SURF or move_effect == CONST.MOVE_EFFECTS.TORBELLINO) and to.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.BUCEO):
		value *= 2.0
	
	if !to.side.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and to.side.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.PANTALLA_LUZ) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5

	if !to.side.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and to.side.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.REFLEJO) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5
	
	### ABILITIES
	
	if to.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and self.makeContact() and !self.is_type(CONST.TYPES.FUEGO):
		value *= 0.5
	elif to.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and !self.makeContact() and self.is_type(CONST.TYPES.FUEGO):
		value *= 2.0
		
	if to.hasWorkingAbility(CONST.ABILITIES.FILTRO) and Type > 1:
		value *= 0.75
	
	if pokemon.hasAlly() and pokemon.ally.hasWorkingAbility(CONST.ABILITIES.COMPIESCOLTA):
		value *= 0.75
		
	if to.hasWorkingAbility(CONST.ABILITIES.COMPENSACION) and to.hasFullHealth():
		value *= 0.50
		
	if to.hasWorkingAbility(CONST.ABILITIES.ARMADURA_PRISMA) and Type > 1:
		value *= 0.75
		
	if to.hasWorkingAbility(CONST.ABILITIES.GUARDIA_ESPECTRO) and to.hasFullHealth():
		value *= 0.50
		
	if pokemon.hasWorkingAbility(CONST.ABILITIES.FRANCOTIRADOR) and critical:
		value *= 1.50
	
	if to.hasWorkingAbility(CONST.ABILITIES.ROCA_SOLIDA) and Type > 1:
		value *= 0.75
		
	if pokemon.hasWorkingAbility(CONST.ABILITIES.CROMOLENTE) and Type < 1:
		value *= 2.0
	
	return value
	### ITEMS
	
func has_multiple_targets():
	if pokemon.listEnemies.size() == 2:
		if has_target(CONST.TARGETS.BASE_ENEMY) or has_target(CONST.TARGETS.ALL_OTHER) or has_target(CONST.TARGETS.ENEMIES) or has_target(CONST.TARGETS.ALL_FIELD) or has_target(CONST.TARGETS.ALL_POKEMON) or has_target(CONST.TARGETS.PLAYERS) or has_target(CONST.TARGETS.BASE_PLAYER):
			return true
		else:
			return false
	else:
		return false
		

func makeContact():
	return contact_flag

func has_target(t):
	return target == t

func moveInflictsDamage():
	return category == CONST.MOVE_CATEGORIES.DAMAGE or category == CONST.MOVE_CATEGORIES.DAMAGE_AILMENT or category == CONST.MOVE_CATEGORIES.DAMAGE_HEAL or category == CONST.MOVE_CATEGORIES.DAMAGE_LOWER or category == CONST.MOVE_CATEGORIES.DAMAGE_RAISE

func moveModifyStats():
	return category == CONST.MOVE_CATEGORIES.CHANGE_STATS or category == CONST.MOVE_CATEGORIES.SWAGGER or category == CONST.MOVE_CATEGORIES.DAMAGE_LOWER or category == CONST.MOVE_CATEGORIES.DAMAGE_RAISE

func moveCausesAilment():
	return category == CONST.MOVE_CATEGORIES.AILMENT or category == CONST.MOVE_CATEGORIES.DAMAGE_AILMENT or category == CONST.MOVE_CATEGORIES.SWAGGER

func calculateAilmentChance():
	randomize()
	var valor : float = randf()
	print("Trying " + Name + " " + str(ailmentChance) + "% chance valor: " + str(valor))
	if valor <= (ailmentChance/100.0):
		return true
	return false
	

func isMultiHit():
	return max_hits > 1
	
func getHits():
	randomize()
	return randi_range(min_hits, max_hits)
	

func doDamage(target : BattlePokemon, damage : int):
	var STAB = calculateSTAB(target)

	print(Name + " damage: " + str(damage))
	
	await target.take_damage(damage)
	
	await GUI.battle.msgBox.showEffectivnessMessage(target, STAB)
#	if STAB >= 2:
#		GUI.battle.showMessage("¡Es muy efectivo!", false, 2.0)
#		await GUI.battle.msgBox.finished
#	elif STAB < 1:
#		GUI.battle.showMessage("No parece muy efectivo...", false, 2.0)
#		await GUI.battle.msgBox.finished
#	elif STAB == 0:
#		GUI.battle.showMessage("No afecta a " + target.Name + ".", false, 2.0)
#		await GUI.battle.msgBox.finished
		
func modifyStats(target : BattlePokemon):
	var i = 0
	var text = ""
	for stat:CONST.STATS in statChangeMod:
		var value =  statChangeValue[i]
		target.battleStatsMod[stat-1] += value
		if value > 0:
			await target.battleSpot.playAnimation("STATUP",{'Stat': stat})
			#await BattleAnimationList.new().getCommonAnimation("StatUp").doAnimation(target.battleSpot)
		elif value < 0:
			await target.battleSpot.playAnimation("STATDOWN",{'Stat': stat})
			#await BattleAnimationList.new().getCommonAnimation("StatDown").doAnimation(target.battleSpot)
		await GUI.battle.msgBox.showStatsMessage(target, stat-1, value)

func causeAilment(target : BattlePokemon):
	if calculateAilmentChance():
		#if ailmentType == CONST.AILMENTS.BURN or ailmentType == CONST.AILMENTS.FREEZE or ailmentType == CONST.AILMENTS.PARALYSIS or ailmentType == CONST.AILMENTS.POISON or ailmentType == CONST.AILMENTS.SLEEP:
		print("Done!")
		await target.changeStatus(pokemon, ailmentType)
		await GUI.battle.msgBox.showAilmentMessage_Move(target, ailmentType)
		return
	print("But failed")
	
func showAnimation(target : BattlePokemon):
	pass
	
func print_move():
	print(" ------ " + str(Name) + " " + str(pp_actual) + "/" + str(pp_total) + " PP ------ ")


func is_type(t):
	return type.id == t
