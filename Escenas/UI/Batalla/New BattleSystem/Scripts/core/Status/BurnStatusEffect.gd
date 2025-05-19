extends StatusEffect
class_name BurnStatusEffect

func on_end_turn(pokemon):
	var damage = floori(pokemon.total_hp / 16.0)
	pokemon.take_damage(damage)
	await BattleUI.message_box.show_message(pokemon.display_name + " sufrió daño por la quemadura.")

func get_display_name() -> String:
	return "QUEMADO"