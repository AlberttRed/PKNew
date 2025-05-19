extends BattleWeatherEffect_Refactor
class_name RainWeatherEffect

var turns_left := 5
var permanent := false

func _init():
	scope = Scope.FIELD
	
func on_start():
	if turns_left == 0 and not permanent:
		turns_left = 5
	await BattleUI.result_display.play_weather_animation("RAIN")
	await BattleUI.message_box.show_message("¡Ha empezado a llover!")

func on_turn_start():
	if permanent:
		return
	if turns_left > 0:
		await BattleUI.message_box.show_message("Sigue lloviendo...")
		await BattleUI.result_display.play_weather_animation("RAIN")

func on_turn_end():
	if permanent:
		return
	turns_left -= 1
	if turns_left <= 0:
		await BattleUI.message_box.show_message("Ha dejado de llover.")
		BattleEffectController.field_effects.erase(self)

func on_calculate_damage(user: BattlePokemon, move: Move, base_damage: int) -> int:
	if move.type.internal_name == "WATER":
		return floori(base_damage * 1.5)
	elif move.type.internal_name == "FIRE":
		return floori(base_damage * 0.5)
	return base_damage
