class_name BattleMoveDamage

#var Damage : int
#var Modifier
#var Att : float
#var Def : float
#var STAB : float = 1.0
#var random : float
##var Targets : float = 1.0
#var Weather : float = 1.0
##var Critical : float = 1.0 # TO DO
#var Weather : float = 1.0
#var Burn : float = 1.0
#var Other : float = 1.0
#

var pkmnLevel : int
var movePower : int
var isCriticalHit : bool
var isPhysicMove : bool
var isSpecialMove : bool
var isFixedDamage : bool = false
var multipleTargets : bool
var Effectiveness : float
var maxDamage : float

var criticalMod : float = 1.0
var targetsMod : float = 1.0
var attackMod : float = 1.0
var deffenseMod : float = 1.0
var randomMod : float
var STABMod : float = 1.0
var weatherMod : float = 1.0
var burnMod : float = 1.0
var otherMod : float = 1.0
var confusedHit : bool = false

var initialDamage : int
var calculatedDamage : int

func _init(_move:BattleMove):
	movePower = _move.power
	pkmnLevel = _move.pokemon.level
	isPhysicMove = _move.damage_class == CONST.DAMAGE_CLASS.FISICO
	isSpecialMove = _move.damage_class == CONST.DAMAGE_CLASS.ESPECIAL
	maxDamage = _move.actualTarget.activePokemon.hp_actual
	confusedHit = _move.confusedHit
	
	isCriticalHit = _move.critical
	multipleTargets = _move.has_multiple_targets() and _move.pokemon.listEnemies.size() > 1
	Effectiveness = _move.calculateEffectivness()
	
	if isPhysicMove:
		#Falta aplicar que si l stage d atac es negatiu, l ignori. I si l stage de defensa rival es positiu, l ignori
		if isCriticalHit && _move.pokemon.getStatStage(CONST.STATS.ATA)<0:
			attackMod = _move.pokemon.attack
		else:
			attackMod = _move.pokemon.getModStat(CONST.STATS.ATA)
		
		if isCriticalHit && _move.actualTarget.activePokemon.getStatStage(CONST.STATS.DEF)>0:
			deffenseMod = _move.actualTarget.activePokemon.defense
		else:
			deffenseMod = _move.actualTarget.activePokemon.getModStat(CONST.STATS.DEF)
	
	elif isSpecialMove:
		if isCriticalHit && _move.pokemon.getStatStage(CONST.STATS.ATAESP)<0:
			attackMod = _move.pokemon.sp_attack
		else:
			attackMod = _move.pokemon.getModStat(CONST.STATS.ATAESP) 
		
		if isCriticalHit && _move.actualTarget.activePokemon.getStatStage(CONST.STATS.DEFESP)>0:
			deffenseMod = _move.actualTarget.activePokemon.sp_defense
		else:	
			deffenseMod = _move.actualTarget.activePokemon.getModStat(CONST.STATS.DEFESP) 

	
	
	
func calculate(r = null):#to : BattlePokemon,r = null):
	if isCriticalHit == null or multipleTargets == null:
		pass
		# show error
	
	if isCriticalHit:
		criticalMod = 2.0
		

	if multipleTargets:
		targetsMod = 0.75

#---- TO DO
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
#---- End TO DO

	if r == null:
		randomize()
		randomMod = randf_range(0.85, 1.0)
		print("random " + str(randomMod))
	else:
		randomMod = r

#---- TO DO
	#Other = calculate_others()
#---- End TO DO
	if !confusedHit:
		initialDamage = int(int((int((2.0 * float(pkmnLevel))/5.0 + 2.0) * float(movePower) * float(attackMod))/float(deffenseMod))/50.0 + 2.0) #(((2 * from.level/5 + 2) * power * Att/Def)/50 + 2)
		calculatedDamage = int(int(int(int(int(int(int(int(initialDamage*targetsMod) * weatherMod) * criticalMod) * randomMod) * STABMod) * Effectiveness) * burnMod) * otherMod)
	else:
		calculatedDamage = int(int((int((2.0 * float(pkmnLevel))/5.0 + 2.0) * float(40) * float(attackMod))/float(deffenseMod))/50.0 + 2.0) #(((2 * from.level/5 + 2) * power * Att/Def)/50 + 2)
	
	calculatedDamage = min(max(1, calculatedDamage), maxDamage)
	
	return calculatedDamage

	#
#func calculate_others():#to,Type,critical):
	#var value = 1.0
#
	#### MOVES
	#if actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.VELO_AURORA) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		#value *= 0.5
		#
	#if (move_effect == CONST.MOVE_EFFECTS.GOLPE_CUERPO or move_effect == CONST.MOVE_EFFECTS.CARGA_DRAGON or self.move_effect == CONST.MOVE_EFFECTS.CUERPO_PESADO or self.move_effect == CONST.MOVE_EFFECTS.PLANCHA_VOLADORA or self.move_effect == CONST.MOVE_EFFECTS.GOLPE_CALOR or self.move_effect == CONST.MOVE_EFFECTS.PISOTON) and actualTarget.activePokemon.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.REDUCCION):
		#value *= 2.0
		#
	#if (move_effect == CONST.MOVE_EFFECTS.TERREMOTO or move_effect == CONST.MOVE_EFFECTS.MAGNITUD) and actualTarget.activePokemon.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.EXCAVAR):
		#value *= 2.0
#
	#if (move_effect == CONST.MOVE_EFFECTS.SURF or move_effect == CONST.MOVE_EFFECTS.TORBELLINO) and actualTarget.activePokemon.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.BUCEO):
		#value *= 2.0
	#
	#if !actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.VELO_AURORA) and actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.PANTALLA_LUZ) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		#value *= 0.5
#
	#if !actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.VELO_AURORA) and actualTarget.activePokemon.side.hasWorkingFieldEffect(BattleEffect.List.REFLEJO) and !critical and !pokemon.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
		#value *= 0.5
	#
	#### ABILITIES
	#
	#if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and self.makeContact() and !self.is_type(CONST.calculatedEffectivnessS.FUEGO):
		#value *= 0.5
	#elif actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and !self.makeContact() and self.is_type(CONST.calculatedEffectivnessS.FUEGO):
		#value *= 2.0
		#
	#if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.FILTRO) and calculatedEffectivness > 1:
		#value *= 0.75
	#
	#if pokemon.hasAlly() and pokemon.ally.hasWorkingAbility(CONST.ABILITIES.COMPIESCOLTA):
		#value *= 0.75
		#
	#if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.COMPENSACION) and actualTarget.activePokemon.hasFullHealth():
		#value *= 0.50
		#
	#if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.ARMADURA_PRISMA) and calculatedEffectivness > 1:
		#value *= 0.75
		#
	#if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.GUARDIA_ESPECTRO) and actualTarget.activePokemon.hasFullHealth():
		#value *= 0.50
		#
	#if pokemon.hasWorkingAbility(CONST.ABILITIES.FRANCOTIRADOR) and critical:
		#value *= 1.50
	#
	#if actualTarget.activePokemon.hasWorkingAbility(CONST.ABILITIES.ROCA_SOLIDA) and calculatedEffectivness > 1:
		#value *= 0.75
		#
	#if pokemon.hasWorkingAbility(CONST.ABILITIES.CROMOLENTE) and calculatedEffectivness < 1:
		#value *= 2.0
	#
	#return value
	#### ITEMS
	#
