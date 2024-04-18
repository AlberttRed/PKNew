class_name BattleChoice

var target : Array[BattleSpot] 
var priority : int = 0 # Ordre de prioritat en la que s'executarà aquesta opció
var type : CONST.BATTLE_ACTIONS
#
func _init(type=CONST.BATTLE_ACTIONS.NONE, priority=0, target: Array[BattleSpot]  = []):
	self.type = type
	self.priority = priority
	if !target.is_empty():
		self.target = target
