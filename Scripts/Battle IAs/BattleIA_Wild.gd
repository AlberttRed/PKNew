extends BattleIA

class_name BattleIA_Wild

#Inteligencia artificial dels Pokemons Salvatges

#Els pokemons salvatges sempre ataquen. Hi ha els casos dels "Roaming" pokemon que intenten escapar-se a cada turn
#pero en aquests casos farem una IA especifica per ells.
	
func selectAction():
	if pokemon.ability == CONST.ABILITIES.RETIRADA:
		if pokemon.HPperectageLeft <= 0.5:
			pokemon.exitBattle()
			return
	
	pokemon.selectMove()
	

func selectMove():
	pokemon.selectedBattleChoice.setMove(getBestMoveChoices().move)



#Obtenim el millor atac possible a fer. En el cas dels pokemon salvatges, ataquen aleatoriament amb qualsevol
#dels atacs que coneixen
func getBestMoveChoices() -> BattleMoveChoice:
	randomize()
	var move_index = randi_range(0, pokemon.moves.size()-1)
	var moveChoice:BattleMoveChoice = BattleMoveChoice.new(pokemon)
	moveChoice.setMove(pokemon.moves[move_index])
	
	#moveChoice.setTarget([pokemon.listEnemies[target_index].battleSpot])
	
	return moveChoice
	
func selectTargets():
	randomize()
	var target_index = randi_range(0, pokemon.listEnemies.size()-1)
	SignalManager.Battle.selectTarget.emit([pokemon.listEnemies[target_index].battleSpot])
	#return BattleMoveChoice.new(pokemon.moves[move_index], [pokemon.listEnemies[target_index]])
