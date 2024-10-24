extends BattleEffect

#func _init(move:BattleMove):
	#super(move)
	#isStatusAilment = true;
	#statusType = CONST.STATUS.PARALYSIS
	#persistentEffect = true
	#
func start():
	pass

func doAnimation():
	await target.battleSpot.playAnimation("PARALYSIS")
	
func applyPreviousEffects():
		randomize()
		var valor : float = randf()
		if valor <= (0.25):
			target.canAttack = false
			await doAnimation()
			await showEffectMessage()
			#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailmentType)

func showEffectSuceededMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " está paralizado! ¡Quizá no pueda moverse!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya está paralizado!", false, 2.0)

func showEffectMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " está paralizado! ¡No se puede mover!", false, 2.0)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya no está paralizado!", false, 2.0)

#func _get(property: StringName) -> Variant:
	#if property.begins_with("resource"):
		#pass
	#return property
