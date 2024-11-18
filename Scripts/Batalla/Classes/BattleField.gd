extends Node2D
class_name BattleField

@export var type : CONST.BATTLE_SIDES = CONST.BATTLE_SIDES.NONE
@export var parentField : BattleField
@export var opponentField : BattleField
var activeBattleEffects : Array[BattleEffect]

var side : BattleSide:
	set(s):
		if type != CONST.BATTLE_TYPES.NONE:
			side = s
			pokemonSpotA.setSide(s)
			pokemonSpotB.setSide(s)

var pokemonSpotA:BattleSpot
var pokemonSpotB:BattleSpot

var trainerSpotA:BattleParticipant
var trainerSpotB:BattleParticipant

var hpBarA:HPBar
var hpBarB:HPBar

func _ready() -> void:
	if type != CONST.BATTLE_TYPES.NONE:
		pokemonSpotA = $PokemonA
		pokemonSpotB = $PokemonB
		trainerSpotA = $TrainerA
		trainerSpotB = $TrainerB
		hpBarA = $HPBarA
		hpBarB = $HPBarB
		


func _init() -> void:
	side = BattleSide.new(self)


func addBattleEffect(effect : BattleEffect):
	if effect == null:
		return
	SignalManager.Battle.Effects.add.emit(effect, self)

func removeBattleEffect(effect : BattleEffect):
	if effect == null:
		return
	SignalManager.Battle.Effects.remove.emit(effect, self)

#func hasWorkingEffect(e:BattleEffect.List):
	#var name:String = str(BattleEffect.List.keys()[e])
	#
	#for effect:BattleEffect in activeBattleEffects:
		#var n = effect.name
		#if(n == name):
			#return true
	#return false

func hasWorkingEffect(effectName:String) -> bool:
	for battleEffect:BattleEffect in activeBattleEffects:
		if effectName == battleEffect.name:
			return true
	return false
	
func hasAilmentEffect(ailmentCode:BattleEffect.Ailments) -> bool:
	return hasWorkingEffect(BattleEffect.Ailments.keys()[ailmentCode])
	
func hasMoveEffect(moveCode:BattleEffect.Moves) -> bool:
	return hasWorkingEffect(BattleEffect.Moves.keys()[moveCode])

func hasWeatherEffect(weatherCode:BattleEffect.Weather) -> bool:
	return hasWorkingEffect(BattleEffect.Weather.keys()[weatherCode])

func getActiveBattleEffects(_pokemon:BattlePokemon):
	var effectList : Array[BattleEffect]
	for e:BattleEffect in activeBattleEffects:
		e.setTarget(_pokemon)
		effectList.push_back(e)
	return effectList
	
func playAnimation(animation:String, animParams:Dictionary = {}):
	SignalManager.Battle.Animations.playAnimation.emit(animation, animParams, self)
	await SignalManager.Animations.finished_animation
