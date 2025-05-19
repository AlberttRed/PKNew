extends StatusEffect
class_name PoisonStatusEffect

func on_end_turn(pokemon):
	var damage = floori(pokemon.total_hp / 8.0)
	pokemon.take_damage(damage)
	await BattleUI.message_box.show_message(pokemon.display_name + " sufrió daño por el veneno.")

func get_display_name() -> String:
	return "ENVENENADO"
