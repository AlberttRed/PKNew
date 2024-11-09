extends BattleEffect


func start():
	pass

func doAnimation():
	await targetPokemon.battleSpot.playAnimation("PARALYSIS")
	
func getPersistent() -> bool:
	return !originPokemon.fainted
	
func applyBattleEffectAtBeforeMove():
		randomize()
		var valor : float = randf()
		if valor <= (0.25):
			targetPokemon.canAttack = false
			await doAnimation()
			await showEffectMessage()
			#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailmentType)

func showEffectSuceededMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " está paralizado! ¡Quizá no pueda moverse!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya está paralizado!", false, 2.0)

func showEffectMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " está paralizado! ¡No se puede mover!", false, 2.0)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya no está paralizado!", false, 2.0)


		
#func _get(property: StringName) -> Variant:
	#if property.begins_with("resource"):
		#pass
	#return property
