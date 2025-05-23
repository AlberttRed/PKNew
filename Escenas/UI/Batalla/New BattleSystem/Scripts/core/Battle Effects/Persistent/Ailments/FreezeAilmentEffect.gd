class_name FreezeAilmentEffect
extends PersistentBattleEffect

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases):
	if phase != BattleEffect_Refactor.Phases.ON_BEFORE_MOVE:
		return
	if randf() < 0.2:
		await ui.show_end_ailment_message(pokemon, source)
		BattleEffectController.remove_pokemon_effect(pokemon, self)
	else:
		await ui.show_ailment_effect_message(pokemon, source)
		pokemon.can_act_this_turn = false
