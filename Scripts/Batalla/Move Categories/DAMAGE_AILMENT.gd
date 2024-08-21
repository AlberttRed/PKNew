extends BattleMoveEffect
# Effect d'atacs que fan mal i modifiquen provoquen ailment /canvi d estat CATEGORY DAMAGE_AILMENT

func doEffect():
	print("CATEGORY DAMAGE_AILMENT")

	if moveInflictsDamage():
		print("Do damage!")
		#Farà animació de colpejar, amb el so
		var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		await move.doDamage(move.actualTarget.activePokemon, damage)


	if moveCausesAilment(): 
		print("Cause ailment!")
		#Farà animació de cremar, dormir, el que sigui
		await move.causeAilment(move.actualTarget.activePokemon)
#
#func doAnimation(to):
	#print("jaja lol")
