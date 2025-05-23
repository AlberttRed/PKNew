class_name RainWeatherEffect
extends PersistentBattleEffect

var duration := 5

func _init():
	pass

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases) -> bool:
	if phase == BattleEffect_Refactor.Phases.ON_ENTRY_BEGIN:
		await ui.messagebox.show_message("¡Comenzó a llover!")
		await ui.weather.play("rain")

	elif phase == BattleEffect_Refactor.Phases.ON_END_TURN:
		duration -= 1
		if duration <= 0:
			await ui.messagebox.show_message("¡La lluvia ha cesado!")
			#BattleEffectController_Refactor.remove_field_effect(self)
		else:
			await ui.messagebox.show_message("¡Sigue lloviendo!")
	return true

func on_modifier(modifier_type: int, move, user, target, value):
	if modifier_type != BattleEffect_Refactor.Modifiers.MOVE_POWER:
		return value

	var move_type = move.get_type().id
	if move_type == "water":
		return value * 1.5
	elif move_type == "fire":
		return value * 0.5
	return value
