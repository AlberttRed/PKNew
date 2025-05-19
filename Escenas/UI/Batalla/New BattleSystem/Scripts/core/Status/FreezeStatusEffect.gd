extends StatusEffect
class_name FreezeStatusEffect

func can_act(pokemon) -> bool:
	if randf() < 0.8:
		await BattleUI.message_box.show_message(pokemon.display_name + " está congelado y no puede moverse.")
		return false
	return true

func get_display_name() -> String:
	return "CONGELADO"
