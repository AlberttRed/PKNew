extends BattleEffect

#func _init(_origin = null, _target = null):
	#super(_origin, _target)
	#calculateTurns()

func start():
	pass

func doAnimation():
	#await GUI.get_tree().create_timer(3).timeout
	await targetPokemon.battleSpot.playAnimation("CONFUSION")
	
func applyBattleEffectAtBeforeMove():
	if !targetPokemon.canAttack:
		return
	if nextTurn():
		await doAnimation()
		await showPreviousEffectMessage()
		randomize()
		var valor : float = randf()
		if valor <= (0.50):#(0.50):
			#targetPokemon.usedMove.damage
			await showEffectMessage()
			targetPokemon.usedMove.target.clear()
			targetPokemon.canAttack = false
			targetPokemon.usedMove.confusedHit = true
			targetPokemon.usedMove.target.selectedTargets = [targetPokemon.battleSpot]
			await targetPokemon.usedMove.calculateDamage()
			await targetPokemon.usedMove.doDamage()
			targetPokemon.usedMove.confusedHit = false
	else:
		await showEffectEndMessage()
		targetPokemon.removeBattleEffect(self)
		
func showEffectSuceededMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " se ecuentra confuso!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya está confuso!", false, 2.0)

func showPreviousEffectMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " está confuso!", false, 1.5)

func showEffectMessage():
	await GUI.battle.showMessage("¡Está tan confuso que se hirió a si mismo!", false, 0.5)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya no está confuso!", false, 2.0)

func clear():
	pass
