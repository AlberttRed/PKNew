extends BattleEffect


func start():
	pass

func doAnimation():
	await targetPokemon.battleSpot.playAnimation("FROZEN")
	
func getPersistent() -> bool:
	return !targetPokemon.fainted
	
func applyBattleEffectAtBeforeMove():
		randomize()
		var valor : float = randf()
		if valor >= (0.20):
			targetPokemon.canAttack = false
			await doAnimation()
			await showEffectMessage()
		else:
			targetPokemon.canAttack = true
			await showEffectEndMessage()
			targetPokemon.removeBattleEffect(self)
			targetPokemon.changeStatus(null)
			#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailmentType)

func showEffectSuceededMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " fue congelado!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya está congelado!", false, 2.0)

func showEffectMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " está congelado!", false, 2.0)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya no está congelado!", false, 2.0)

		
#func _get(property: StringName) -> Variant:
	#if property.begins_with("resource"):
		#pass
	#return property
