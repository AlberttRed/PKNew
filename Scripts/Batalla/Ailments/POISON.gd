extends BattleAilmentEffect

var badPoison:bool = false
var badPoisonCounter:int = 0

func _init(move:BattleMove):
	super(move)
	isStatusAilment = true
	statusType = CONST.STATUS.POISON
	persistentEffect = true

func start():
	pass
	
func doAnimation():
	await target.battleSpot.playAnimation("POISON")
	
func applyLaterEffects():
	await showAilmentEffectMessage()
	await doAnimation()
	await target.take_damage(calculatePoisonDamage())

func calculatePoisonDamage() -> int:
	var damage: int
	if badPoison:
		badPoisonCounter += 1
		damage = target.hp_total * (float(badPoisonCounter)/16.0) # 1|16
	else:
		damage = target.hp_total * (1.0/8.0) # 1|8
		
	return max(1, floor(damage))

func showAilmentSuceededMessage():
	if badPoison:
		await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " fue gravemente envenenado!", false, 2.0)
	else:
		await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " fue envenenado!", false, 2.0)

func showAilmentRepeatedMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya está evenenado!", false, 2.0)

func showAilmentEffectMessage():
	await GUI.battle.showMessage("¡El veneno resta PS " + target.battleMessageMiddleAlName + "!", false, 1.0)

func showAilmentEndMessage():
	await GUI.battle.showMessage("¡" + target.battleMessageInitialName + " ya no está envenenado!", false, 2.0)
