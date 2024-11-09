extends BattleMoveCategoryEffect
# Effect d'atacs que fan mal i pugen stats CATEGORY DAMAGE_RAISE

func doEffect():
	print("CATEGORY DAMAGE_RAISE")

	if moveInflictsDamage():
		print("Do damage!")
		#Farà animació de colpejar, amb el so
		#var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		#await move.doDamage(move.actualTarget.activePokemon, damage)

		await move.calculateDamage()
		await move.doDamage()

	if moveModifyStats() and !pokemon.fainted:
		print("Modify stat!")
		if move.calculateChangeStatChance():
			await move.modifyStats(pokemon)

#func doAnimation(to):
	#print("jaja lol")
