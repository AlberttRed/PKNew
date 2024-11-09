class_name BattleMove

signal updateHP
signal actionSelected

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
var final_hits : int = 0

var min_turns : int
var max_turns : int

var drainPercentage : int
var healAmount : int
var moveHits : bool # Indica si el moviment falla/ha fallat o no
var statChangeMod : Array[CONST.STATS]
var statChangeValue : Array[int]
var ailmentType : CONST.AILMENTS
var ailmentChance : int :
	get:
		if ailmentType != CONST.AILMENTS.NONE and ailmentChance == 0:
			return 100
		return ailmentChance
var statChangeChance : int

var calculatedEffectivness : float
var calculatedHealing : int

var target_type : BattleTarget.TYPE
#var move_effect : CONST.MOVE_EFFECTS
var category : CONST.MOVE_CATEGORIES

var target: BattleTarget:
	set(t):
		#ailment.target = t
		target = t
var actualTarget:
	get:
		if target==null:
			return null
		return target.actualTarget

var damage_class : CONST.DAMAGE_CLASS
var contact_flag : bool = false

var effect : BattleEffect #Move Effect
var moveCategoryeffect : BattleMoveCategoryEffect
var ailment : BattleEffect
var animation : Animation#BattleMoveAnimation
var hasAnimationPlayed:bool = false
var damage : BattleMoveDamage
var confusedHit : bool = false

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
	target_type = _move.base.target_id
	target = BattleTarget.new(self)
	category = _move.base.meta_category_id
	damage_class = _move.damage_class as CONST.DAMAGE_CLASS
	contact_flag = _move.base.contact_flag
	min_hits = _move.base.meta_min_hits
	max_hits = _move.base.meta_max_hits
	min_turns = _move.base.meta_min_turns
	max_turns = _move.base.meta_max_turns
	drainPercentage = _move.base.meta_drain
	healAmount = _move.base.meta_healing
	statChangeMod = _move.base.stat_change_ids as Array[CONST.STATS]
	statChangeValue = _move.base.stat_change_valors
	ailmentType = _move.base.meta_ailment_id
	ailmentChance = _move.base.meta_ailment_chance
	statChangeChance = _move.base.effect_chance
	
	
	pokemon = _pokemon	
	var name:String = str(CONST.MOVE_CATEGORIES.keys()[category])
	moveCategoryeffect = load("res://Scripts/Batalla/Move Categories/"+CONST.MOVE_CATEGORIES.keys()[category]+".gd").new(self)
	print("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentType]+".gd")
	#if FileAccess.file_exists("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentType+1]+".gd"):
		#ailmentResource = load("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentType+1]+".gd")
	var n = instance.internalName.to_upper()
#	if FileAccess.file_exists("res://Animaciones/Batalla/Moves/Classes/" + str(n) + ".gd") != null:
	if FileAccess.file_exists("res://Animaciones/Batalla/Moves/Anim/" + str(n) + ".res"):
			#animation = load("res://Animaciones/Batalla/Moves/Classes/" + str(n) + ".gd").new(self)
		animation = load("res://Animaciones/Batalla/Moves/Anim/" + str(n) + ".res")#.init(self)
	if BattleEffect.getAilment(ailmentType) != null:
		ailment = BattleEffect.getAilment(ailmentType).new(pokemon)
		ailment.effectChance = ailmentChance
		ailment.minTurns = min_turns
		ailment.maxTurns = max_turns
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Moves/" + str(n) + ".gd"):
		effect = load("res://Scripts/Batalla/Effects/Moves/" + str(n) + ".gd").new(pokemon)
		
func use():
	calculateHits() 
	#await pokemon.applyPreviousEffects()
	
	await GUI.battle.msgBox.showMoveMessage(pokemon, self)

	while target.nextTarget():
		calculateAccuracy()
		while _checkHit():
			target.actualTarget.addBattleEffect(effect)
			calculateCriticalHit()
			await doAnimation()
			final_hits+=1
			if effect!=null:
				await effect.doEffect()
			await moveCategoryeffect.doEffect()
			if critical:
				await GUI.battle.showMessage("¡Un golpe crítico!", false, 2.0)
				critical = false
		
		if !moveHits:
			await GUI.battle.showMessage("¡El ataque " + pokemon.battleMessageMiddleDelName + " falló!", false, 2.0)
		elif isMultiHit():
			await GUI.battle.showMessage("N.º de golpes: " + str(final_hits) + ".", false, 2.0)
		
		if target.actualTarget is BattleSpot:
			await target.actualTarget.activePokemon.checkFainted()
		#await actualTarget.activePokemon.updatePokemonState()
	
	target.clear()
	actualTarget = null
	final_hits = 0
	hasAnimationPlayed=false
	#await pokemon.applyLaterEffects()
		
#func doAnimation(target):
	#var animParams:Dictionary = {'Target':target}
	#SignalManager.BATTLE.playAnimation.emit(instance.internalName.to_upper(), animParams, pokemon.battleSpot)
	##playAnimation.emit(instance.internalName.to_upper(), animParams)
	#await SignalManager.ANIMATION.finished_animation
	##await animation.doAnimation(target)

func doAnimation():
	if animation != null && !hasAnimationPlayed:
		SignalManager.Battle.Animations.playAnimation.emit(animation.init(self), {}, pokemon.battleSpot)
		#Nomes marquem l'animació com a played quan el move no es multihit, ja que si es multihit s'ha de reproduir x vegades
		hasAnimationPlayed = !isMultiHit()
		#playAnimation.emit(instance.internalName.to_upper(), animParams)
		await SignalManager.Animations.finished_animation
		#await animation.doAnimation(target)
		
func is_physic_category():
	return damage_class == CONST.DAMAGE_CLASS.FISICO

func is_special_category():
	return damage_class == CONST.DAMAGE_CLASS.ESPECIAL
	
func is_status_category():
	return damage_class == CONST.DAMAGE_CLASS.ESTADO
	
func calculateEffectivness():
	var STAB_type1 : float = 1.0
	var STAB_type2 : float = 1.0
	
	STAB_type1 = type.get_effectiveness_against(actualTarget.activePokemon.types[0])
#	print(type.Name + " against " + target.types[0].Name)
#	print("STAB1 " + str(STAB_type1))
	if actualTarget.activePokemon.types[1] != null:
#		print(type.Name + " against " + target.types[1].Name)
		STAB_type2 = type.get_effectiveness_against(actualTarget.activePokemon.types[1])
#		print("STAB2 " + str(STAB_type2))
		
	print("total STAB1(" + str(STAB_type1) + ") * STAB2(" + str(STAB_type2) + ") = " + str(float(STAB_type1) * float(STAB_type2)))
	calculatedEffectivness = float(STAB_type1) * float(STAB_type2)
	return calculatedEffectivness
	
func calculateDamage(r = null):
	damage = BattleMoveDamage.new(self)
	#SignalManager.Battle.Effects.applyAt.emit("CalculateDamage")
	#await SignalManager.Battle.Effects.finished
	await GUI.battle.controller.effects.applyBattleEffect("CalculateDamage")
	damage.calculate()
	print("Stats Stages: AT: " + str(pokemon.getStatStage(CONST.STATS.ATA)) + ", DEF: " + str(pokemon.getStatStage(CONST.STATS.DEF)) + ", ATESP: " + str(pokemon.getStatStage(CONST.STATS.ATAESP)) + ", DEFESP: " + str(pokemon.getStatStage(CONST.STATS.DEFESP)) + ", VEL: " + str(pokemon.getStatStage(CONST.STATS.VEL)) + ", ACC: " + str(pokemon.getStatStage(CONST.STATS.ACC)) + ", EVA: " + str(pokemon.getStatStage(CONST.STATS.EVA)))
	print("Level: " + str(pokemon.level) + ", Power: " + str(power) + ", Attack: " + str(damage.attackMod) + ", Def: " + str(damage.deffenseMod) + ", Nature:" + str(CONST.NaturesName[pokemon.instance.nature_id]) + ", Rival nature:" + str(CONST.NaturesName[actualTarget.activePokemon.instance.nature_id]))
	print("Damage: " + str(damage.calculatedDamage))
	print("Targets: " + str(damage.targetsMod) + ", Weather: " + str(damage.weatherMod) + ", Critical: " + str(damage.criticalMod) + ", Random: " + str(damage.randomMod) + ", STAB: " + str(damage.STABMod) + ", Ef: " + str(damage.Effectiveness) + ", Burn: " + str(damage.burnMod) + ", Other: " + str(damage.otherMod))

		#Fem el minim amb l hp actual perque si fem mes mal, que vida té el pokemon, com a maxim ens retorni la vida que li queda
	
	
#func calculateDamage(r = null):#to : BattlePokemon,r = null):
	#var Damage : int
	##var Modifier
	#var Att : float
	#var Def : float
	#var STAB : float = 1.0
	#var random : float
	#var Targets : float = 1.0
	#var Weather : float = 1.0
	#var Critical : float = 1.0 # TO DO
	#var Burn : float = 1.0
	#var Other : float = 1.0
	#
	#if critical:
		#Critical = 2.0
		#
	#if is_physic_category():
		##Falta aplicar que si l stage d atac es negatiu, l ignori. I si l stage de defensa rival es positiu, l ignori
		#if critical && pokemon.getStatStage(CONST.STATS.ATA)<0:
			#Att = pokemon.attack
		#else:
			#Att = pokemon.getModStat(CONST.STATS.ATA)
		#
		#if critical && pokemon.getStatStage(CONST.STATS.DEF)<0:
			#Def = actualTarget.activePokemon.defense
		#else:
			#Def = actualTarget.activePokemon.getModStat(CONST.STATS.DEF)
	#
	#elif is_special_category():
		#if critical && pokemon.getStatStage(CONST.STATS.ATAESP)<0:
			#Att = pokemon.sp_attack
		#else:
			#Att = pokemon.getModStat(CONST.STATS.ATAESP) 
		#
		#if critical && pokemon.getStatStage(CONST.STATS.DEFESP)<0:
			#Def = actualTarget.activePokemon.sp_defense
		#else:	
			#Def = actualTarget.activePokemon.getModStat(CONST.STATS.DEFESP) 
	#
	#if has_multiple_targets() and pokemon.listEnemies.size() > 1 :
		#Targets = 0.75
#
	#if GUI.battle.controller.activeWeather == CONST.WEATHER.LLUVIOSO:
		#if type.id == CONST.TYPES.FUEGO:
			#Weather = 0.5
		#elif type.id == CONST.TYPES.AGUA:
			#Weather = 1.5
	#elif GUI.battle.controller.activeWeather == CONST.WEATHER.SOLEADO:
		#if type.id == CONST.TYPES.FUEGO:
			#Weather = 1.5
		#elif type.id == CONST.TYPES.AGUA:
			#Weather = 0.5
#
	#if pokemon.types.has(type) and pokemon.hasWorkingAbility(CONST.ABILITIES.ADAPTABLE):
		#STAB = 2
	#elif pokemon.types.has(type) and !pokemon.hasWorkingAbility(CONST.ABILITIES.ADAPTABLE):
		#STAB = 1.5
#
	#if pokemon.status == CONST.STATUS.BURNT and !pokemon.hasWorkingAbility(CONST.ABILITIES.AGALLAS) and (!is_special_category() and move_effect == CONST.MOVE_EFFECTS.IMAGEN):
		#Burn = 0.5
#
##	if to.types[1] != null:
##		Ef = Ef * type.get_effectiveness_against(to.types[1])
#
	#if r == null:
		#randomize()
		#random = randf_range(0.85, 1.0)
		#print("random " + str(random))
	#else:
		#random = r
		#
	#calculateEffectivness()
	#Other = calculate_others()#to,Ef,false)
#
	#Damage = int(int((int((2.0 * float(pokemon.level))/5.0 + 2.0) * float(power) * float(Att))/float(Def))/50.0 + 2.0) #(((2 * from.level/5 + 2) * power * Att/Def)/50 + 2)
	#print("Stats Stages: AT: " + str(pokemon.getStatStage(CONST.STATS.ATA)) + ", DEF: " + str(pokemon.getStatStage(CONST.STATS.DEF)) + ", ATESP: " + str(pokemon.getStatStage(CONST.STATS.ATAESP)) + ", DEFESP: " + str(pokemon.getStatStage(CONST.STATS.DEFESP)) + ", VEL: " + str(pokemon.getStatStage(CONST.STATS.VEL)) + ", ACC: " + str(pokemon.getStatStage(CONST.STATS.ACC)) + ", EVA: " + str(pokemon.getStatStage(CONST.STATS.EVA)))
	#print("Level: " + str(pokemon.level) + ", Power: " + str(power) + ", Attack: " + str(Att) + ", Def: " + str(Def) + ", Nature:" + str(CONST.NaturesName[pokemon.instance.nature_id]) + ", Rival nature:" + str(CONST.NaturesName[actualTarget.activePokemon.instance.nature_id]))
	#print("Damage: " + str(Damage))
	#print("Targets: " + str(Targets) + ", Weather: " + str(Weather) + ", Critical: " + str(Critical) + ", Random: " + str(random) + ", STAB: " + str(STAB) + ", Ef: " + str(calculatedEffectivness) + ", Burn: " + str(Burn) + ", Other: " + str(Other))
	#calculatedDamage = int(int(int(int(int(int(int(int(Damage*Targets) * Weather) * Critical) * random) * STAB) * calculatedEffectivness) * Burn) * Other)
	#
	#calculatedDamage = max(1, calculatedDamage)
	##Fem el minim amb l hp actual perque si fem mes mal, que vida té el pokemon, com a maxim ens retorni la vida que li queda
	#return min(calculatedDamage, actualTarget.activePokemon.hp_actual)
	
func calculate_others():#to,Type,critical):
	var value = 1.0

	### MOVES
	if actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.VELO_AURORA) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5
		
	#if (move_effect == CONST.MOVE_EFFECTS.GOLPE_CUERPO or move_effect == CONST.MOVE_EFFECTS.CARGA_DRAGON or self.move_effect == CONST.MOVE_EFFECTS.CUERPO_PESADO or self.move_effect == CONST.MOVE_EFFECTS.PLANCHA_VOLADORA or self.move_effect == CONST.MOVE_EFFECTS.GOLPE_CALOR or self.move_effect == CONST.MOVE_EFFECTS.PISOTON) and actualTarget.activePokemon.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.REDUCCION):
		#value *= 2.0
		#
	#if (move_effect == CONST.MOVE_EFFECTS.TERREMOTO or move_effect == CONST.MOVE_EFFECTS.MAGNITUD) and actualTarget.activePokemon.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.EXCAVAR):
		#value *= 2.0
#
	#if (move_effect == CONST.MOVE_EFFECTS.SURF or move_effect == CONST.MOVE_EFFECTS.TORBELLINO) and actualTarget.activePokemon.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.BUCEO):
		#value *= 2.0
	
	if !actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.VELO_AURORA) and actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.PANTALLA_LUZ) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5

	if !actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.VELO_AURORA) and actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.REFLEJO) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		value *= 0.5
	
	### ABILITIES
	
	if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and self.makeContact() and !self.is_type(CONST.calculatedEffectivnessS.FUEGO):
		value *= 0.5
	elif actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and !self.makeContact() and self.is_type(CONST.calculatedEffectivnessS.FUEGO):
		value *= 2.0
		
	if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.FILTRO) and calculatedEffectivness > 1:
		value *= 0.75
	
	if pokemon.hasAlly() and pokemon.ally.hasWorkingAbility(CONST.ABILITIES.COMPIESCOLTA):
		value *= 0.75
		
	if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.COMPENSACION) and actualTarget.activePokemon.hasFullHealth():
		value *= 0.50
		
	if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.ARMADURA_PRISMA) and calculatedEffectivness > 1:
		value *= 0.75
		
	if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.GUARDIA_ESPECTRO) and actualTarget.activePokemon.hasFullHealth():
		value *= 0.50
		
	if pokemon.hasWorkingAbility(CONST.ABILITIES.FRANCOTIRADOR) and critical:
		value *= 1.50
	
	if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.ROCA_SOLIDA) and calculatedEffectivness > 1:
		value *= 0.75
		
	if pokemon.hasWorkingAbility(CONST.ABILITIES.CROMOLENTE) and calculatedEffectivness < 1:
		value *= 2.0
	
	return value
	### ITEMS
	
func calculateCriticalHit():
	var probability:float = CONST.BATTLE_STAGE_MULT_CRITICAL[pokemon.criticalStage]
	
	randomize()
	var n:float = randf_range(0.1, 100)#randf_range(min_hits, max_hits)
	
	critical = n <= probability && damage_class != CONST.DAMAGE_CLASS.ESTADO

func calculateAccuracy():
	if actualTarget is not BattleSpot or target.type == BattleTarget.TYPE.USER:
		moveHits = true
		return
	var targetPokemon:BattlePokemon = actualTarget.activePokemon
	var calculatedProbability:float
	var moveAccuracy:float = float(accuracy)
	var finalStage:int = max(-6, min(pokemon.getStatStage(CONST.STATS.ACC) - targetPokemon.getStatStage(CONST.STATS.EVA), 6)) # EL modificador de precisió com a minim pot ser -6 i maxim 6
	var stagedAccuracy:float = CONST.BATTLE_STAGE_MULT_EVACC[finalStage]
	var other:float = 1.0 # TO DO
	
	calculatedProbability = moveAccuracy * stagedAccuracy * other
	
	randomize()
	var n:float = randf_range(0.1, 100)
	
	moveHits = n <= calculatedProbability

func calculateHealing():#damage: int):
	var healValue : int = 0
	if drainPercentage != null and drainPercentage > 0:
		healValue= floor(damage.calculatedDamage*(drainPercentage/100.0))
	elif healAmount != null:
		healValue= floor(actualTarget.activePokemon.hp_total*(healAmount/100.0))
	else:
		assert(false, Name + " movement has no drain percentage nor amount informed")
	calculatedHealing = healValue
	
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
	return target_type == t

func moveInflictsDamage():
	return category == CONST.MOVE_CATEGORIES.DAMAGE or category == CONST.MOVE_CATEGORIES.DAMAGE_AILMENT or category == CONST.MOVE_CATEGORIES.DAMAGE_HEAL or category == CONST.MOVE_CATEGORIES.DAMAGE_LOWER or category == CONST.MOVE_CATEGORIES.DAMAGE_RAISE

func moveModifyStats():
	return category == CONST.MOVE_CATEGORIES.CHANGE_STATS or category == CONST.MOVE_CATEGORIES.SWAGGER or category == CONST.MOVE_CATEGORIES.DAMAGE_LOWER or category == CONST.MOVE_CATEGORIES.DAMAGE_RAISE

func moveCausesAilment():
	return category == CONST.MOVE_CATEGORIES.AILMENT or category == CONST.MOVE_CATEGORIES.DAMAGE_AILMENT or category == CONST.MOVE_CATEGORIES.SWAGGER
	

func isMultiHit():
	return max_hits > 1
	
func calculateHits():
	if min_hits == max_hits:
		num_hits = max_hits
	else:
		randomize()
		var n:float = randf_range(0.1, 100)#randf_range(min_hits, max_hits)
		
		match true:
			_ when n >= 0.1 and n <= 37.5:
				num_hits =  2
			_ when n >= 37.6 and n <= 75.0:
				num_hits =  3
			_ when n >= 75.1 and n <= 82.5:
				num_hits =  4
			_ when n >= 82.6 and n <= 100.0:
				num_hits =  5

#Checks if there has finalized all hits/strikes for a multistike move
func _checkHit() -> bool:
	var fainted:bool = (actualTarget is BattleSpot and actualTarget.activePokemon.fainted)
	#SignalManager.Battle.Effects.applyAt.emit("CheckHit")
	#await SignalManager.Battle.Effects.finished
	var effectHits = effect == null || effect.effectHits
	moveHits = moveHits && effectHits
	return moveHits and final_hits < num_hits and !fainted
	

func doDamage():#target : BattlePokemon, damage : int):
	#var STAB = calculateSTAB(target.actualTarget.activePokemon)
	
	print(Name + " damage: " + str(damage.calculatedDamage))
	await target.actualTarget.playAnimation("HIT")
	await target.actualTarget.activePokemon.takeDamage(damage)
	
	if !confusedHit:
		await GUI.battle.msgBox.showEffectivnessMessage(target.actualTarget.activePokemon, calculatedEffectivness)

func doHealing(targetToHeal : BattlePokemon):#, heal : int):
	
	print(Name + " heal: " + str(calculatedHealing))
	
	await targetToHeal.heal(calculatedHealing)#, CONST.HEAL_TYPE.MOVE)
	
	#GUI.battle.showMessage("¡" + targetToHeal.battleMessageInitialName + " ha recuprado vida!", false, 2.0)

func modifyStats(targetToModify : BattlePokemon):
	var i = 0
	var text = ""
	for stat:CONST.STATS in statChangeMod:
		var value =  statChangeValue[i]
		await targetToModify.changeModStat(stat-1, value)
		i+=1
		#target.battleStatsMod[stat-1] += value
		#if value > 0:
			#await target.battleSpot.playAnimation("STATUP",{'Stat': stat})
			##await BattleAnimationList.new().getCommonAnimation("StatUp").doAnimation(target.battleSpot)
		#elif value < 0:
			#await target.battleSpot.playAnimation("STATDOWN",{'Stat': stat})
			##await BattleAnimationList.new().getCommonAnimation("StatDown").doAnimation(target.battleSpot)
		#await GUI.battle.msgBox.showStatsMessage(target, stat-1, value)

func causeAilment():
	if ailment == null:
		assert(false, "Move " + Name + " has no ailment configured.")
		return
	ailment.calculateTurns()
	ailment.setTarget(target.actualTarget)
	#ailment = BattleEffect.getAilment(ailmentType).new(pokemon,target)#(self)
	if actualTarget.activePokemon.hasWorkingEffect(ailment):
		await ailment.showEffectRepeatedMessage()
		return
	elif actualTarget.activePokemon.hasStatusAilment() and ailment.type == BattleEffect.Type.STATUS:
		await GUI.battle.showMessage("¡El ataque " + pokemon.battleMessageMiddleDelName + " falló!", false, 2.0)
		return
			
	if ailment.calculateEffectChance():
		print("Done!")
		await ailment.doAnimation()
		await ailment.showEffectSuceededMessage()
		await actualTarget.activePokemon.changeStatus(ailment)
		#await GUI.battle.msgBox.showAilmentMessage_Move(actualTarget.activePokemon, newAilment.ailmentType)

	
func calculateChangeStatChance() -> bool:
	randomize()
	var valor : float = randf()
	if valor <= (statChangeChance/100.0):
		return true
	return false

func selectTargets():
	target.clear()
	target.selectTargets()
	
func showAnimation(target : BattlePokemon):
	pass
	
func print_move():
	print(" ------ " + str(Name) + " " + str(pp_actual) + "/" + str(pp_total) + " PP ------ ")


func is_type(t):
	return type.id == t
