class_name BattleWeatherEffect extends BattleEffect

#Effect que es crida cada turn quan s'activa un clima en combat

var weatherType : CONST.WEATHER
#var ailmentChance : int

static func getWeather(weatherCode : CONST.WEATHER) -> Resource:
	if FileAccess.file_exists("res://Scripts/Batalla/Weathers/"+CONST.WEATHER.keys()[weatherCode+1]+".gd"):
		return load("res://Scripts/Batalla/Weathers/"+CONST.WEATHER.keys()[weatherCode+1]+".gd")
	return null

func _init():
	pass
	#ailmentType = move.ailmentType
	#ailmentChance = move.ailmentChance
	#minTurns = move.min_turns
	#maxTurns =  move.max_turns
	#target = move.pokemon


func applyPreviousEffects():
	pass

func applyLaterEffects():
	pass
#
#func calculateAilmentChance():
	#randomize()
	#var valor : float = randf()
	#print("Trying " + move.pokemon.Name + " " + str(ailmentChance) + "% chance valor: " + str(valor))
	#if valor <= (ailmentChance/100.0):
		#return true
	#return false
	#
	
func showWeatherStartedMessage():
	assert(false, "Please override showWeatherStartedMessage()` in the derived script.")
	
func showWeatherRepeatedMessage():
	assert(false, "Please override showWeatherRepeatedMessage()` in the derived script.")

func showWeatherEffectMessage():
	assert(false, "Please override showWeatherEffectMessage()` in the derived script.")

func showWeatherEndedMessage():
	assert(false, "Please override showWeatherEndedMessage()` in the derived script.")
