class_name BattleEffect

signal finished

static func getAilment(ailmentCode : CONST.AILMENTS) -> Resource:
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Ailments/"+CONST.AILMENTS.keys()[ailmentCode+1]+".gd"):
		return load("res://Scripts/Batalla/Effects/Ailments/"+CONST.AILMENTS.keys()[ailmentCode+1]+".gd")
	return null
	
static func getAbility(abilityCode : CONST.ABILITIES) -> Resource:
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Abilities/"+CONST.ABILITIES.keys()[abilityCode]+".gd"):
		return load("res://Scripts/Batalla/Effects/Abilities/"+CONST.ABILITIES.keys()[abilityCode]+".gd")
	return null

static func getMove(moveCode : Moves) -> Resource:
	if Moves.keys().size() < moveCode:
		return null
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Moves/"+Moves.keys()[moveCode]+".gd"):
		return load("res://Scripts/Batalla/Effects/Moves/"+Moves.keys()[moveCode]+".gd")
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

enum Moves {
	REFLECT = 115,
	CONFUSE_RAY = 109
}

enum Type {
	MOVE,
	STATUS,
	AILMENT,
	ABILITY,
	WEATHER	
}

enum Priority {
	LOWEST,
	LOW,
	MIDDLE,
	HIGH,
	HIGHEST
}

var originPokemon : BattlePokemon
var targetPokemon : BattlePokemon
var priority : Priority:
	get:
		return getPriority()
var targetField : BattleField
var effectChance : int
var effectHits : bool #Indicate if the effect/move misses or not
#var _origin = null # BattleMove | Abilty, Ailment


var pokemon : BattlePokemon
var persistent:bool:
	get:
		return getPersistent()
	#get:
		#return maxTurns == 0 and minTurns == 0

var minTurns:int = 0:
	set(min):
		if min == null:
			min = 0
		turnsCounter = 0
		minTurns = min
var maxTurns :int = 0:
	set(max):
		if max == null:
			max = 0
		turnsCounter = 0
		maxTurns = max

var turnsCounter:int
var activeTurns:int

func _init(_origin = null, _target = null):
	setOrigin(_origin)
	setTarget(_target)

func setOrigin(_origin):
	if _origin == null:
		return
	if _origin is BattleMove:
		self.originPokemon = _origin.pokemon
	elif _origin is BattlePokemon:
		self.originPokemon = _origin
	else:
		assert(false, "Not a valid origin type for BattleEffect " + str(self.name))

func setOriginPokemon(_pokemon:BattlePokemon):
	self.originPokemon = _pokemon
	
func setTarget(_target):
	if _target == null:
		return
	if _target is BattleField:
		self.targetField = _target
	elif _target is BattlePokemon:
		self.targetPokemon = _target
	elif _target is BattleSpot:
		self.targetPokemon = _target.activePokemon
	else:
		assert(false, "Not a valid target type for BattleEffect " + str(self.name))
		return
	effectHits = checkHitEffect()

func getPriority() -> int:
	if self.type == Type.STATUS:
		return Priority.HIGH
	else:
		return Priority.LOWEST

func getPersistent() -> bool:
	return false
	
	
func doEffect():
	assert(false, "Please override doEffect()` in the derived script.")

func checkHitEffect() -> bool:
	return true


func clear():
	assert(false, "Please override clear()` in the derived script.")

func calculateTurns():
	randomize()
	turnsCounter=0
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
	
#region New Code Region
	
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
	
func applyBattleEffectAtTakeDamage():
	pass

func applyBattleEffectAtEscapeBattle():
	pass
	
func applyBattleEffectAtBeforeMove():
	pass
	
func applyBattleEffectAtAfterMove():
	pass
#endregion

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
		return 	get_script().get_path().get_file().trim_suffix('.gd')
	if property == "type":
		var array = get_script().get_path().split("/")
		array.reverse()
		var typeName = array[1]
		match typeName:
			"Abilities":
				return Type.ABILITY
			"Ailments":
				var effectName = self.name
				if effectName == "PARALYSIS" || effectName == "BURN" || effectName == "SLEEP" || effectName == "FREEZE" || effectName == "POISON":
					return Type.STATUS
				return Type.AILMENT
			"Moves":
				return Type.MOVE
			_:
				return null
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
