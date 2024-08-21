class_name BattleMoveEffect extends BattleEffect

var move : BattleMove
#func doEffect(to: Array[BattlePokemon]):
#	assert(false, "Please override doEffect()` in the derived script.")

func _init(_move : BattleMove):
	super._init(_move.pokemon)
	move = _move
	
func doAnimation(target):
	assert(false, "Please override doAnimation()` in the derived script.")


func moveInflictsDamage():
	return move.moveInflictsDamage()

func moveModifyStats():
	return move.moveModifyStats()

func moveCausesAilment():
	return move.moveCausesAilment()
