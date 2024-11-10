extends BattleEffect

func start():
	pass
	
func doAnimation():
	await targetPokemon.battleSpot.playAnimation("BURN")

func getPersistent() -> bool:
	return !targetPokemon.fainted
	
func applyBattleEffectAtAfterMove():
	await doAnimation()
	await showEffectMessage()
	await targetPokemon.takeDamage(calculateBurnDamage())
	
func applyBattleEffectAtCalculateDamage():
	if targetPokemon.usedMove.damage.isPhysicMove and !targetPokemon.hasAbilityEffect(Abilities.GUTS) and !targetPokemon.usedMove.equals(BattleEffect.Moves.FACADE):
		var newDamage :int = floori(targetPokemon.usedMove.damage.calculatedDamage / 2.0)
		targetPokemon.usedMove.damage.calculatedDamage = max(1, newDamage)

func calculateBurnDamage() -> BattleMoveDamage:
	var calculatedDamage: int
	var damage : BattleMoveDamage = BattleMoveDamage.new()
	var divisor : float = 8.0 if !targetPokemon.hasAbilityEffect(Abilities.HEATPROOF) else 16.0
	calculatedDamage = targetPokemon.hp_total * (1.0/8.0) # 1|8
	damage.calculatedDamage = max(1, floor(calculatedDamage))
	return damage

func showEffectSuceededMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " se ha quemado!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya está quemado!", false, 2.0)

func showEffectMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " se resiente de la quemadura!", false, 1.0)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya no está quemado!", false, 2.0)
