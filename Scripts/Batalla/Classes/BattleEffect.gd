class_name BattleEffect

static func getAilment(ailmentCode : CONST.AILMENTS) -> Resource:
	if FileAccess.file_exists("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentCode+1]+".gd"):
		return load("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentCode+1]+".gd")
	return null
	
static func getAbility(abilityCode : CONST.ABILITIES) -> Resource:
	var name = CONST.ABILITIES.keys()[abilityCode]
	if FileAccess.file_exists("res://Scripts/Batalla/Abilities/"+CONST.ABILITIES.keys()[abilityCode]+".gd"):
		return load("res://Scripts/Batalla/Abilities/"+CONST.ABILITIES.keys()[abilityCode]+".gd")
	return null

enum List {
	PARALYSIS,
	BURN,
	SLEEP,
	FREEZE,
	POISON,
	VELO_AURORA,
	PANTALLA_LUZ,
	REFLEJO,
	ALLANAMIENTO
}

enum Type {
	MOVE,
	STATUS,
	AILMENT,
	ABILITY,
	WEATHER	
}

var originPokemon : BattlePokemon
#var originMove : BattleMove
var target = null: # BattlePokemon | BattleSpot | BattleSide
	#get:
		#if target is BattleTarget:
			#return target.actualTarget.activePokemon
		#return target
	set(e):
		if e is BattleSpot:
			target = e.activePokemon
		else:
			target = e
var effectChance : int
var type = null
#var _origin = null # BattleMove | Abilty, Ailment


var pokemon : BattlePokemon
var persistent:bool:
	get:
		return maxTurns == 0 and minTurns == 0

var minTurns:int = 0:
	set(min):
		turnsCounter = 0
		minTurns = min
var maxTurns :int = 0:
	set(max):
		turnsCounter = 0
		maxTurns = max

var turnsCounter:int
var activeTurns:int

func _init(_originPokemon : BattlePokemon = null, _target = null):
	self.originPokemon = _originPokemon
	if _target is BattleTarget:
		self.target = target.actualTarget.activePokemon
	else:
		self.target = _target
	

func doEffect():
	assert(false, "Please override doEffect()` in the derived script.")

func clear():
	assert(false, "Please override clear()` in the derived script.")

func calculateTurns():
	randomize()
	activeTurns = randi_range(minTurns,maxTurns)

func nextTurn():
	turnsCounter += 1
	return turnsCounter <= activeTurns

func calculateEffectChance():
	randomize()
	var valor : float = randf()
	#print("Trying " + move.pokemon.Name + " " + str(ailmentChance) + "% chance valor: " + str(valor))
	if valor <= (effectChance/100.0):
		return true
	return false
	
func applyPreviousEffects():
	pass
	

func applyLaterEffects():
	pass
	
func applyBattleEffectAtInitBattleTurn():
	pass
	
func applyBattleEffectAtEndBattleTurn():
	pass

func applyBattleEffectAtInitPKMNTurn():
	pass
	
func applyBattleEffectAtEndPKMNTurn():
	pass

func applyBattleEffectAtCalculateDamage():
	pass

func showEffectSuceededMessage():
	assert(false, "Please override showEffectSuceededMessage()` in the derived script.")
	
func showEffectRepeatedMessage():
	assert(false, "Please override showEffectRepeatedMessage()` in the derived script.")

func showEffectMessage():
	assert(false, "Please override showEffectMessage()` in the derived script.")

func showEffectEndMessage():
	assert(false, "Please override showEffectEndMessage()` in the derived script.")


#Get the name of the script(without .gd) as the name
func _get(property: StringName) -> Variant:
	if property == "name":
		print(get_script().get_path().get_file().trim_suffix('.gd'))
		return 	get_script().get_path().get_file().trim_suffix('.gd')
	return property
#
#func setOrigin(origin):
	#if origin is BattleMove:
		#pass
#
	#
#func setTarget(target):
	#if target is BattlePokemon:
		#pass
	#elif target is BattleSide:
		#pass
#
#func doAnimation():
#	assert(false, "Please override doAnimation()` in the derived script.")
#
#
#func moveInflictsDamage():
#	return move.moveInflictsDamage()
#
#func moveModifyStats():
#	return move.moveModifyStats()
#
#func moveCausesAilment():
#	return move.moveCausesAilment()
