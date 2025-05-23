class_name PersistentBattleEffect
extends BattleEffect_Refactor

var source # Ailment/Ability/Weather

func _init(_source) -> void:
	source = _source

func on_phase(pokemon, ui, phase): return true

func on_modifier(modifier_type: int, move, user, target, value): return value
