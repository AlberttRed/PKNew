extends StatusEffect
class_name SleepStatusEffect

var turns_left := 3

func on_turn_start(pokemon):
	if turns_left > 0:
		turns_left -= 1
		await BattleUI.message_box.show_message(pokemon.display_name + " sigue dormido.")
	else:
		pokemon.status = null
		await BattleUI.message_box.show_message(pokemon.display_name + " se despertó.")

func can_act(pokemon):
	return turns_left <= 0

func get_display_name() -> String:
	return "DORMIDO"
