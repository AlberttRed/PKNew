extends BattleMoveAilmentEffect

func _init(move:BattleMove):
	super(move)
	isStatusAilment = true;
	statusType = CONST.STATUS.SLEEP

func doAnimation():
	pass
	#await target.battleSpot.playAnimation("SLEEP")
	
func applyPreviousEffects():
		randomize()
		var valor : float = randf()
		if valor <= (0.25):
			target.canAttack = false
			await doAnimation()
			await showAilmentEffectMessage()#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailmentType)

func showAilmentSuceededMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " se durmió!", false, 2.0)

func showAilmentRepeatedMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya está dormido!", false, 2.0)

func showAilmentEffectMessage():
	await GUI.battle.showMessage(target.battleMessageInitialName + " está dormido como un tronco.", false, 2.0)

func showAilmentEndMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " se despertó!", false, 2.0)
