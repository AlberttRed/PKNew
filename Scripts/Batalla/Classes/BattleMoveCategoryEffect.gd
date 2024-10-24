class_name BattleMoveCategoryEffect

var move : BattleMove
var pokemon : BattlePokemon:
	get:
		return move.pokemon
var target : BattlePokemon:
	get:
		return move.actualTarget.activePokemon
#func doEffect(to: Array[BattlePokemon]):
#	assert(false, "Please override doEffect()` in the derived script.")

func _init(_move : BattleMove):
	move = _move
	#
func moveInflictsDamage():
	return move.moveInflictsDamage()

func moveModifyStats():
	return move.moveModifyStats()

func moveCausesAilment():
	return move.moveCausesAilment()
