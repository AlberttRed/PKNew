class_name PoisonAilmentEffect
extends PersistentBattleEffect

func on_phase(pokemon: BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: BattleEffect_Refactor.Phases):
	if phase != BattleEffect_Refactor.Phases.ON_END_TURN:
		return
	var dmg:int = ceil(pokemon.total_hp / 8.0)
	var effect := DamageEffect.new(null, pokemon, null, dmg)
	effect.show_effectiveness = false
	pokemon.take_damage(effect)
	await ui.show_ailment_effect_message(pokemon, source)
	await pokemon.battle_spot.apply_damage()
