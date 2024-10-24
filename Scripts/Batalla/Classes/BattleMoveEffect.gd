class_name BattleMoveEffect

var move : BattleMove
var target : BattlePokemon
#func doEffect(to: Array[BattlePokemon]):
#	assert(false, "Please override doEffect()` in the derived script.")

func _init(_move : BattleMove):
	#super._init(_move.pokemon)
	target = _move.actualTarget.activePokemon
	move = _move
	#
func doAnimation():
	assert(false, "Please override doAnimation()` in the derived script.")


func moveInflictsDamage():
	return move.moveInflictsDamage()

func moveModifyStats():
	return move.moveModifyStats()

func moveCausesAilment():
	return move.moveCausesAilment()
