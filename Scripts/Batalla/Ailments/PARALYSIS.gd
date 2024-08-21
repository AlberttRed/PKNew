extends BattleAilmentEffect



func doAnimation():
	await target.battleSpot.playAnimation("PARALYSIS")
	
func applyPreviousEffects():
		randomize()
		var valor : float = randf()
		if valor <= (0.25):
			target.canAttack = false
			await doAnimation()
			await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)

func showAilmentSuceededMessage():
	GUI.battle.showMessage("¡" + target.Name + " está paralizado! ¡No se puede mover!", false, 2.0)
	
func showAilmentFailedMessage():
	GUI.battle.showMessage("¡El ataque de " + pokemon.Name + " falló!", false, 2.0)
	
func showAilmentRepeatedMessage():
	GUI.battle.showMessage("¡El " + target.Name + " salvaje ya está paralizado!", false, 2.0)
