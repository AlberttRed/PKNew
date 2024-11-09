extends BattleAilmentEffect

func _init(move:BattleMove):
	super(move)
	isStatusAilment = true;
	statusType = CONST.STATUS.SLEEP
	persistentEffect = true
	calculateTurns()

func start():
	turnsCounter = 0
	
func doAnimation():
	await target.battleSpot.playAnimation("SLEEP")
	
func applyPreviousEffects():
	if nextTurn():
		target.canAttack = false
		await doAnimation()
		await showAilmentEffectMessage()
	else:
		target.canAttack = true
		await showAilmentEndMessage()
		target.changeStatus(null)

func showAilmentSuceededMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " se durmió!", false, 2.0)

func showAilmentRepeatedMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya está dormido!", false, 2.0)

func showAilmentEffectMessage():
	await GUI.battle.showMessage(target.battleMessageInitialName + " está dormido como un tronco.", false, 2.0)

func showAilmentEndMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " se despertó!", false, 2.0)
