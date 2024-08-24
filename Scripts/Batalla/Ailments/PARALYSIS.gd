extends BattleMoveAilmentEffect

func _init(move:BattleMove):
	super(move)
	isStatusAilment = true;
	statusType = CONST.STATUS.PARALYSIS

func doAnimation():
	await target.battleSpot.playAnimation("PARALYSIS")
	
func applyPreviousEffects():
		randomize()
		var valor : float = randf()
		if valor <= (0.25):
			target.canAttack = false
			await doAnimation()
			await showAilmentEffectMessage()
			#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailmentType)

func showAilmentSuceededMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " está paralizado! ¡Quizá no pueda moverse!", false, 2.0)

func showAilmentRepeatedMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya está paralizado!", false, 2.0)

func showAilmentEffectMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " está paralizado! ¡No se puede mover!", false, 2.0)

func showAilmentEndMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya no está paralizado!", false, 2.0)
