class_name BattleField

var parentField : BattleField
var activeBattleEffects : Array[BattleEffect]
var side : BattleSide

func _init(_side:BattleSide = null, _parent : BattleField = null) -> void:
	side = _side
	parentField = _parent


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
