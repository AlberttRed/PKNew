class_name SleepAilmentEffect
extends PersistentBattleEffect

var turns_left := randi_range(1, 3)

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases):
	if phase != BattleEffect_Refactor.Phases.ON_BEFORE_MOVE:
		return
	if turns_left <= 0:
		await ui.show_end_ailment_message(pokemon, source)
		BattleEffectController.remove_pokemon_effect(pokemon, self) 
	else:
		await ui.show_ailment_effect_message(pokemon, source)
		turns_left -= 1
		pokemon.can_act_this_turn = false 
