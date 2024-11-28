extends BattleEffect

var activated = false # Indicates if intimidation has already been activated, as only will be applied the first time

func doIntimidation():
	if !activated:
		for enemy:BattlePokemon in originPokemon.listEnemies:
			await enemy.changeModStat(CONST.STATS.ATA, -1, false)
			await GUI.battle.showMessageWait("¡Intimidación " + originPokemon.battleMessageMiddleDelName + " baja el ataque " + enemy.battleMessageMiddleDelName + "!", 2.0)
		activated = true

func applyBattleEffectAtInitBattleTurn():
	await doIntimidation()

func applyBattleEffectAtEndPKMNTurn():
	await doIntimidation()
	
func clear():
	activated = false
