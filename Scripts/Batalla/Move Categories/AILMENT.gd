extends BattleMoveCategoryEffect
# Effect d'atacs que només proquen ailment / canvi d estat : CATEGORY AILMENT

func doEffect():
	print("CATEGORY AILMENT")

	var target:BattlePokemon = move.actualTarget.activePokemon
	if moveCausesAilment():
		print("Cause ailment!")
		await move.causeAilment()
