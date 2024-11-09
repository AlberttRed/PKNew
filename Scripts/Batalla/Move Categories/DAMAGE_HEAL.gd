extends BattleMoveCategoryEffect
# Effect d'atacs que fan mal i curen CATEGORY DAMAGE_HEAL

func doEffect():
	print("CATEGORY DAMAGE_HEAL")

	if moveInflictsDamage():
		print("Do damage!")
		#Farà animació de colpejar, amb el so
		#var damage : int =  move.calculateDamage(move.actualTarget.activePokemon)
		#await move.doDamage(move.actualTarget.activePokemon, damage)

		await move.calculateDamage()
		await move.doDamage()
		
		#var heal: int = move.calculateHealing(damage)
		#await move.doHealing(move.pokemon, heal)
		
		await move.calculateHealing()
		await move.doHealing(move.pokemon)
		
		#missatge is drained
		await GUI.battle.showMessage("¡" + move.actualTarget.activePokemon.battleMessageInitialName + " ha perdido energía!", false, 1.0)
				
#func doAnimation(to):
	#print("jaja lol")
