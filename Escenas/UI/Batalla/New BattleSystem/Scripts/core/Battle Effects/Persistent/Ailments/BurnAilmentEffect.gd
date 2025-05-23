class_name BurnAilmentEffect
extends PersistentBattleEffect

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases):
	if phase != BattleEffect_Refactor.Phases.ON_END_TURN:
		return

	var dmg:int = ceil(pokemon.get_max_hp() / 16.0)

	var burn_effect := DamageEffect.new(null, pokemon, null, dmg)
	burn_effect.show_effectiveness = false
	burn_effect.is_critical = false
	burn_effect.effectiveness = 1.0

	pokemon.take_damage(burn_effect)

	await ui.show_ailment_effect_message(pokemon, source)
	await pokemon.battle_spot.apply_damage()
