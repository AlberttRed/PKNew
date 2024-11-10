extends BattleEffect


func start():
	pass
	
func doAnimation():
	await targetPokemon.battleSpot.playAnimation("SLEEP")

func getPersistent() -> bool:
	return !targetPokemon.fainted
	
func applyBattleEffectAtBeforeMove():
	if nextTurn():
		targetPokemon.canAttack = false
		await doAnimation()
		await showEffectMessage()
	else:
		targetPokemon.canAttack = true
		await showEffectEndMessage()
		targetPokemon.removeBattleEffect(self)
		targetPokemon.changeStatus(null)

func showEffectSuceededMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " se durmió!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya está dormido!", false, 2.0)

func showEffectMessage():
	await GUI.battle.showMessage(targetPokemon.battleMessageInitialName + " está dormido como un tronco.", false, 2.0)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " se despertó!", false, 2.0)
