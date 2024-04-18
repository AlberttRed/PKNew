class_name BattleEffect

var pokemon : BattlePokemon
var isStatus : bool

func _init(_pokemon : BattlePokemon, _isStatus = false):
	pokemon = _pokemon
	isStatus = _isStatus

func doEffect(to: Array[BattleSpot]):
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
