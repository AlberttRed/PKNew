extends StatusEffect
class_name ParalysisStatusEffect

func can_act(pokemon) -> bool:
	if randf() < 0.25:
		await BattleUI.message_box.show_message(pokemon.display_name + " está paralizado. ¡No se puede mover!")
		return false
	return true

func get_display_name() -> String:
	return "PARALIZADO"
