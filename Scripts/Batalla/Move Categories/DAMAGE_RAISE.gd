extends BattleMoveCategoryEffect
# Effect d'atacs que fan mal i pugen stats CATEGORY DAMAGE_RAISE

func doEffect():
	print("CATEGORY DAMAGE_RAISE")

	if moveInflictsDamage():
		print("Do damage!")
		#Farà animació de colpejar, amb el so
		var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		await move.doDamage(move.actualTarget.activePokemon, damage)


	if moveModifyStats():
		print("Modify stat!")
		#Farà animació de baixar o pujar stats, amb el so
		await move.modifyStats(move.actualTarget.activePokemon)

#func doAnimation(to):
	#print("jaja lol")
