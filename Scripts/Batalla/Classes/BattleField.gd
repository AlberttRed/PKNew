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

func hasWorkingEffect(effect:BattleEffect):
	for battleEffect:BattleEffect in activeBattleEffects:
		if effect.name == battleEffect.name:
			return true
	return false
