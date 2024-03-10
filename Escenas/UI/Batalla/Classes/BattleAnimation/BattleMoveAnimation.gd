class_name BattleMoveAnimation

var move : BattleMove

func _init(_move :BattleMove):
	move = _move

func doAnimation(_target : BattlePokemon):
	assert(false, "Please override doAnimation()` in the derived script.")

