extends BattleMoveCategoryEffect
# Effect d'atacs que fan mal i modifiquen provoquen ailment /canvi d estat CATEGORY DAMAGE_AILMENT

func doEffect():
	print("CATEGORY DAMAGE_AILMENT")

	if moveInflictsDamage():
		print("Do damage!")
		#var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		#await move.doDamage(move.actualTarget.activePokemon, damage)
		await move.calculateDamage()
		await move.doDamage()

	#Si provoca ailment, i el target no te l ailment ni tampoc es un ailment d status ja tinguent el target un status
	if moveCausesAilment()  and !target.fainted and !move.actualTarget.activePokemon.hasWorkingEffect(move.ailment) and !(move.actualTarget.activePokemon.hasStatusAilment() and move.ailment.isStatusAilment):
		print("Cause ailment!")
		await move.causeAilment()
#
