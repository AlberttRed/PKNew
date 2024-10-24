extends BattleMoveCategoryEffect
#Moviments que únicament curen CATEGORY HEAL

func doEffect():
	print("CATEGORY HEAL")

	#var heal: int = move.healAmount
	#await move.doHealing(move.pokemon, heal)
	
	move.calculateHealing()
	await move.doHealing(target)
	
	#missatge is drained
	await GUI.battle.showMessage("¡" + move.actualTarget.activePokemon.battleMessageInitialName + " recuperó salud!", false, 1.0)
