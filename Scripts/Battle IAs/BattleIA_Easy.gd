extends BattleIA

class_name BattleIA_Easy


	
func selectAction():
	pokemon.selectMove()

func selectMove():
	pokemon.selected_move = getBestMoveChoice().move
	
#Obtenim el millor atac possible a fer, en aquest serà el moviment que causi més mal al rival
func getBestMoveChoice() -> BattleMoveChoice:
	var choices : Array[BattleMoveChoice] = []
	var bestChoices : Array[BattleMoveChoice] = []
	for m in pokemon.moves:
		if m.causesDamage():
			for e in pokemon.listEnemies:
				var damage = m.get_damage(e)
				if m.has_multiple_targets() and pokemon.listEnemies.size() > 1 :
					choices.push_back(BattleMoveChoice.new(m, pokemon.listEnemies, damage))
				else:
					choices.push_back(BattleMoveChoice.new(m, [e], damage))
				
	#Seleccionem el/s moviment/s que faci/n més mal.
	var last_damage = 0
	for c in choices:
		if c.damage > last_damage:
			bestChoices = [c]
		elif c.damage == last_damage:
			bestChoices.push_back(c)
			
	if bestChoices.size() > 1:
		# Si hi ha dos moviments que son igual de bons, en seleccionem 1 a l'atzar
		randomize()
		return bestChoices[randi_range(0, bestChoices.size()-1)]
	elif bestChoices.size() == 1:
		return bestChoices[0]
	else:
		#Si no hi ha cap best choice, vol dir que no te cap moviment que faci mal. Per aquesta IA en seleccionem 1 a l'atzar
		randomize()
		return choices[randi_range(0, choices.size()-1)]
