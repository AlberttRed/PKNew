extends BattleMoveCategoryEffect
# Effect d'atacs que fan mal i baixen stats CATEGORY DAMAGE_LOWER

func doEffect():
	print("CATEGORY DAMAGE_LOWER")


	if moveInflictsDamage():
		print("Do damage!")
		#Farà animació de colpejar, amb el so
		#var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		#await move.doDamage(move.actualTarget.activePokemon, damage)

		move.calculateDamage()
		await move.doDamage()

	if moveModifyStats() and !target.fainted:
		print("Modify stat!")
		if move.calculateChangeStatChance():
			await move.modifyStats(target)

#func doAnimation(to):
	#print("jaja lol")
