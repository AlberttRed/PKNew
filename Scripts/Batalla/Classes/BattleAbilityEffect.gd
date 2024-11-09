class_name BattleAbilityEffect extends BattleEffect

#var ability : CONST.ABILITIES
##func doEffect(to: Array[BattlePokemon]):
##	assert(false, "Please override doEffect()` in the derived script.")
#
#func _init(_ability : CONST.ABILITIES, _pokemon : BattlePokemon):
#	super._init(_pokemon)
#	ability = _ability

func doAnimation():
	assert(false, "Please override doAnimation()` in the derived script.")
