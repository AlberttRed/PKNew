extends BattleEffect

var badPoison:bool = false
var badPoisonCounter:int = 0

func start():
	pass
	
func doAnimation():
	await targetPokemon.battleSpot.playAnimation("POISON")

func getPersistent() -> bool:
	return !targetPokemon.fainted
	
func applyBattleEffectAtAfterMove():
	await showEffectMessage()
	await doAnimation()
	
	await targetPokemon.takeDamage(calculatePoisonDamage())

func calculatePoisonDamage() -> BattleMoveDamage:
	var calculatedDamage: int
	var damage : BattleMoveDamage = BattleMoveDamage.new()
	if badPoison:
		badPoisonCounter += 1
		calculatedDamage = targetPokemon.hp_total * (float(badPoisonCounter)/16.0) # 1|16
	else:
		calculatedDamage = targetPokemon.hp_total * (1.0/8.0) # 1|8
	damage.calculatedDamage = max(1, floor(calculatedDamage))
	return damage

func showEffectSuceededMessage():
	if badPoison:
		await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " fue gravemente envenenado!", false, 2.0)
	else:
		await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " fue envenenado!", false, 2.0)

func showEffectRepeatedMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya está evenenado!", false, 2.0)

func showEffectMessage():
	await GUI.battle.showMessage("¡El veneno resta PS " + targetPokemon.battleMessageMiddleAlName + "!", false, 1.0)

func showEffectEndMessage():
	await GUI.battle.showMessage("¡" + targetPokemon.battleMessageInitialName + " ya no está envenenado!", false, 2.0)
