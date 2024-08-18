class_name BattleMoveAnimation extends Animation

var move : BattleMove
var origin : BattlePokemon

#func _init(_move :BattleMove):
	#self.move = _move
	#self.origin = _move.pokemon

func _init():
	pass
	
func doAnimation(_target : BattleSpot):
	assert(false, "Please override doAnimation()` in the derived script.")
