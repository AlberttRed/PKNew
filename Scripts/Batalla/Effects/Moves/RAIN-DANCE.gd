extends BattleEffect

func doEffect():
	# FALTA ANIMACIÓ
	var rainEffect:BattleEffect = BattleEffect.getWeather(BattleEffect.Weather.RAIN).new(null, targetField)
	targetField.addBattleEffect(rainEffect)
	targetField.removeBattleEffect(self)
	await rainEffect.doEffect()

func checkHitEffect() -> bool:
	return !targetField.hasWeatherEffect(BattleEffect.Weather.RAIN)
