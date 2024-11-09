extends BattleEffect

func applyBattleEffectAtCalculateDamage():
	var newAttack :int

	if originPokemon.hasStatusAilment() and originPokemon.status != CONST.STATUS.FROZEN:
		newAttack = floori(originPokemon.usedMove.damage.attackMod * 1.5)
		originPokemon.usedMove.damage.attackMod = newAttack
	
func clear():
	pass
	#originPokemon.selected_move.damage.movePower = originPokemon.selected_move.power 
