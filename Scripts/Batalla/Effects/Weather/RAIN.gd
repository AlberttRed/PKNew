extends BattleEffect

var permanent=false

func applyBattleEffectAtInitBattleTurn():
	if turnsCounter == 0:
		permanent = true
		await doEffect()

func doEffect():
	if 	activeTurns == 0 && !permanent:
		activeTurns = 5
	turnsCounter = 1
	await doAnimation()
	await GUI.battle.showMessage("¡Ha empezado a llover!", false, 2.0)

func doAnimation():
	#await GUI.get_tree().create_timer(3).timeout
	await targetField.playAnimation("RAIN")
	
func applyBattleEffectAtCalculateDamage():
	if targetPokemon.usedMove.isType(CONST.TYPES.WATER):
		var newDamage :int = floori(targetPokemon.usedMove.damage.calculatedDamage * 1.5)
		targetPokemon.usedMove.damage.calculatedDamage = max(1, newDamage)
	elif targetPokemon.usedMove.isType(CONST.TYPES.FIRE):
		var newDamage :int = floori(targetPokemon.usedMove.damage.calculatedDamage * 0.5)
		targetPokemon.usedMove.damage.calculatedDamage = max(1, newDamage)
		
func applyBattleEffectAtEndBattleTurn():
	if nextTurn() || permanent:
		await GUI.battle.showMessage("Sigue lloviendo...", false, 1.0)
		await doAnimation()
	else:
		await GUI.battle.showMessage("Ha dejado de llover.", false, 2.0)
		targetField.removeBattleEffect(self)
		turnsCounter = 0
		activeTurns = 0
