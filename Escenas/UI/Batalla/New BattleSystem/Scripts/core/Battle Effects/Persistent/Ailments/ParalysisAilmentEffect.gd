class_name ParalysisAilmentEffect
extends PersistentBattleEffect

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases):
	if phase != BattleEffect_Refactor.Phases.ON_BEFORE_MOVE:
		return

	if randf() < 0.25:
		await ui.show_ailment_effect_message(pokemon, source)
		pokemon.can_act_this_turn = false
