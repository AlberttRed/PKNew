extends BattleEffect

func applyBattleEffectAtEscapeBattle():
	originPokemon.canEscape = true
	var msg:String = "¡"+originPokemon.battleMessageInitialName + " escapó usando FUGA!"
	await GUI.battle.showMessageWait(msg, 1.5)
	
func clear():
	pass
	#originPokemon.selected_move.damage.movePower = originPokemon.selected_move.power 
