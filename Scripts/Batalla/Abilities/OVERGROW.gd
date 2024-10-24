extends BattleEffect

func doEffect():
	var power :int
	var hpPercentage = floori(originPokemon.hp_total / 3.0)
	if originPokemon.hp_actual <= hpPercentage:
		power = floori(originPokemon.usedMove.damage.movePower * 1.5)
		originPokemon.usedMove.damage.movePower = power
	
	#else:
		#power = originPokemon.selected_move.damage.movePower
func applyBattleEffectAtCalculateDamage():
	doEffect()
	
func clear():
	pass
	#originPokemon.selected_move.damage.movePower = originPokemon.selected_move.power 
