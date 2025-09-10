extends PersistentBattleEffect
class_name IntimidateAbilityEffect

func apply_phase(pokemon:BattlePokemon_Refactor, phase: Phases) -> void: 
	if phase != Phases.ON_ENTRY:
		return 

	# Aplica -1 ataque a cada enemigo activo
	var enemies := pokemon.side.opponent_side.get_active_pokemons()
	for target:BattlePokemon_Refactor in enemies:
		target.stat_stages.decrease(StatTypes.Stat.ATTACK, 1)

func visualize_phase(pokemon:BattlePokemon_Refactor, ui: BattleUI_Refactor, phase: Phases) -> void:
	if phase != Phases.ON_ENTRY:
		return

	var enemies := pokemon.side.opponent_side.get_active_pokemons()
	for target:BattlePokemon_Refactor in enemies:
		#await ui.messagebox.show_message("¡La Intimidación de %s afecta a %s!" % [source.get_name(), target.get_name()])
		await ui.show_ability_effect_message(pokemon, target, source)
	
func get_priority() -> int:
	return 10
