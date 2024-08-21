class_name BattleEffect

var pokemon : BattlePokemon

func _init(_pokemon : BattlePokemon):
	pokemon = _pokemon

func doEffect():
	assert(false, "Please override doEffect()` in the derived script.")


func applyPreviousEffects():
	pass
	

func applyLaterEffects():
	pass


#
#func doAnimation():
#	assert(false, "Please override doAnimation()` in the derived script.")
#
#
#func moveInflictsDamage():
#	return move.moveInflictsDamage()
#
#func moveModifyStats():
#	return move.moveModifyStats()
#
#func moveCausesAilment():
#	return move.moveCausesAilment()
