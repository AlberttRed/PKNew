extends BattleMoveEffect
# Effect d'atacs que només proquen ailment / canvi d estat : CATEGORY AILMENT

func doEffect():
	print("CATEGORY AILMENT")

	#doAnimation(to)
	#for bs:BattleSpot in to:
	var target:BattlePokemon = move.actualTarget.activePokemon
	if moveCausesAilment(): 
		print("Cause ailment!")
		#Farà animació de cremar, dormir, el que sigui
		if target.status != CONST.STATUS.OK:
			await GUI.battle.showMessage("¡El ataque de " + move.pokemon.Name + " falló!", false, 1.5)
		else:
			await move.causeAilment(target)

#func doAnimation(to):
	#print("jaja lol")
