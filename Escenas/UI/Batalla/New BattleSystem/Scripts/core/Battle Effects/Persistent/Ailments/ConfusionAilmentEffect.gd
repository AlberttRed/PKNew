class_name ConfusionAilmentEffect
extends PersistentBattleEffect

var turns_left := randi_range(2, 5)

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases):
	if phase != BattleEffect_Refactor.Phases.ON_BEFORE_MOVE:
		return

	if turns_left <= 0:
		await ui.show_end_ailment_message(pokemon, source)
		BattleEffectController.remove_pokemon_effect(pokemon, self)
		return

	await ui.show_ailment_previous_effect_message(pokemon, source)
	turns_left -= 1

	if randf() < 0.5:
		return  # Puede actuar normalmente
	else:
		var damage:int = ceil(pokemon.get_max_hp() / 8.0)
		var effect := DamageEffect.new(pokemon, pokemon, null, damage)
		effect.show_effectiveness = false
		pokemon.take_damage(effect)
		await ui.show_ailment_effect_message(pokemon, source)
		await pokemon.battle_spot.apply_damage()
		pokemon.can_act_this_turn = false
