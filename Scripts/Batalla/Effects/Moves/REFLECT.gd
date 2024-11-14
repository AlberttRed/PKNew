extends BattleEffect

var damageDivisor:float = 2.0

func doEffect():
	if turnsCounter == 0:
		turnsCounter = 1
		activeTurns = 5
		# FALTA ANIMACIÓ
		if targetField.side.controllable:
			await GUI.battle.showMessage("¡Reflejo subió la Defensa de tu equipo!", false, 2.0)
		else:
			await GUI.battle.showMessage("¡Reflejo subió la Defensa del equipo rival!", false, 2.0)

func checkHitEffect() -> bool:
	return !targetField.hasWorkingEffect(self.name)
	#else:
		#power = originPokemon.selected_move.damage.movePower
func applyBattleEffectAtTakeDamage():
	if targetPokemon.receivedDamage.isPhysicMove && !targetPokemon.receivedDamage.isCriticalHit && !targetPokemon.receivedDamage.isFixedDamage:
		var newDamage :int = floori(targetPokemon.receivedDamage.calculatedDamage / 2.0)
		targetPokemon.receivedDamage.calculatedDamage = max(1, newDamage)

func applyBattleEffectAtInitBattleTurn():
	if !nextTurn():
		if targetField.side.controllable:
			await GUI.battle.showMessage("¡Reflejo no funciona en tu equipo!", false, 2.0)
		else:
			await GUI.battle.showMessage("¡Reflejo no funciona en el equipo rival!", false, 2.0)
		targetField.removeBattleEffect(self)
		turnsCounter = 0
		activeTurns = 0
