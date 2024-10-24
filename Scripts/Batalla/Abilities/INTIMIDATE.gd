extends BattleEffect

var activated = false # Indicates if intimidation has already been activated, as only will be applied the first time

func doEffect():
	if !activated:
		for enemy:BattlePokemon in originPokemon.listEnemies:
			await enemy.changeModStat(CONST.STATS.ATA, -1, false)
			await GUI.battle.showMessage("¡Intimidación " + target.battleMessageMiddleDelName + " baja el ataque " + enemy.battleMessageMiddleDelName + "!", false, 2.0)
		activated = true

func applyBattleEffectAtInitBattleTurn():
	await doEffect()

func applyBattleEffectAtEndPKMNTurn():
	await doEffect()
	
func clear():
	activated = false
