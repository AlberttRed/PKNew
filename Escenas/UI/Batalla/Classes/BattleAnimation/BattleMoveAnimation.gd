class_name BattleMoveAnimation

var move : BattleMove
var origin : BattlePokemon

func _init(_move :BattleMove):
	self.move = _move
	self.origin = _move.pokemon

func doAnimation(_target : BattlePokemon):
	assert(false, "Please override doAnimation()` in the derived script.")

