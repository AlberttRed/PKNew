extends BattleMoveCategoryEffect
# Effect d'atacs simples, que només fan mal CATEGORY DAMAGE

func doEffect():
	print("CATEGORY DAMAGE")

	#await doAnimation(to)
	if moveInflictsDamage():
		print("Do damage!")
		#Farà animació de colpejar, amb el so
		var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		await move.doDamage(move.actualTarget.activePokemon, damage)

#func doAnimation(to):
	#await move.doAnimation(to[0])
