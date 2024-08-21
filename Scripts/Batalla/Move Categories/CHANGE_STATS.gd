extends BattleMoveEffect
# Effect d'atacs que només modifiquen stats  CATEGORY CHANGE_STATS

func doEffect():
	print("CATEGORY CHANGE_STATS")

	if moveModifyStats():
		print("Modify stat!")
		#Farà animació de baixar o pujar stats, amb el so
		await move.modifyStats(move.actualTarget.activePokemon)

#func doAnimation(to):
	#print("jaja lol")
