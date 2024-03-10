class_name BattleMoveEffect extends BattleEffect

var move : BattleMove
#func doEffect(to: Array[BattlePokemon]):
#	assert(false, "Please override doEffect()` in the derived script.")

func _init(_move : BattleMove, _pokemon : BattlePokemon):
	super._init(_pokemon)
	move = _move
	
func doAnimation():
	assert(false, "Please override doAnimation()` in the derived script.")


func moveInflictsDamage():
	return move.moveInflictsDamage()

func moveModifyStats():
	return move.moveModifyStats()

func moveCausesAilment():
	return move.moveCausesAilment()
