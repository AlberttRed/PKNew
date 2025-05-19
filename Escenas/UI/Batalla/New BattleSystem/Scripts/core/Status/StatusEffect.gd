class_name StatusEffect
extends Resource

func on_turn_start(pokemon: BattlePokemon) -> void:
	pass

func on_end_turn(pokemon: BattlePokemon) -> void:
	pass

func can_act(pokemon: BattlePokemon) -> bool:
	return true

func get_display_name() -> String:
	return "ESTADO"
