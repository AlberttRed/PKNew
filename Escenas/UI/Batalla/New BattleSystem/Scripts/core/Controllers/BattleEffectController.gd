extends Node
class_name BattleEffectController

var ui_ref: BattleUIRef = BattleUIRef.new()

var field_effects: Array[BattleEffect] = []
var side_effects: Dictionary = {} # {BattleSide: Array[BattleEffect]}
var pokemon_effects: Dictionary = {} # {BattlePokemon: Array[BattleEffect]}

func set_ui(message_box, result_display):
	ui_ref.message_box = message_box
	ui_ref.result_display = result_display

func register_effect(effect: BattleEffect, source_pokemon: BattlePokemon):
	effect.battle_ui = ui_ref
	match effect.scope:
		BattleEffect_Refactor.Scope.FIELD:
			register_field_effect(effect)
		BattleEffect_Refactor.Scope.SIDE:
			register_side_effect(effect, source_pokemon.owner_side)
		BattleEffect_Refactor.Scope.POKEMON:
			register_pokemon_effect(effect, source_pokemon)


func register_field_effect(effect: BattleEffect):
	if not field_effects.has(effect):
		field_effects.append(effect)

func register_side_effect(effect: BattleEffect, side):
	if not side_effects.has(side):
		side_effects[side] = []
	if not side_effects[side].has(effect):
		side_effects[side].append(effect)

func register_pokemon_effect(effect: BattleEffect, pokemon):
	if not pokemon_effects.has(pokemon):
		pokemon_effects[pokemon] = []
	if not pokemon_effects[pokemon].has(effect):
		pokemon_effects[pokemon].append(effect)

func get_all_effects_for(pokemon) -> Array:
	var all_effects: Array = []
	all_effects += pokemon_effects.get(pokemon, [])
	all_effects += side_effects.get(pokemon.owner_side, [])
	all_effects += field_effects
	return all_effects

func apply_on_turn_start(pokemon):
	for effect in get_all_effects_for(pokemon):
		if effect.has_method("on_turn_start"):
			await effect.on_turn_start()

func apply_on_turn_end(pokemon):
	for effect in get_all_effects_for(pokemon):
		if effect.has_method("on_turn_end"):
			await effect.on_turn_end()

func apply_on_calculate_damage(pokemon, move, base_damage: int) -> int:
	var final_damage = base_damage
	for effect in get_all_effects_for(pokemon):
		if effect.has_method("on_calculate_damage"):
			final_damage = effect.on_calculate_damage(pokemon, move, final_damage)
	return final_damage
