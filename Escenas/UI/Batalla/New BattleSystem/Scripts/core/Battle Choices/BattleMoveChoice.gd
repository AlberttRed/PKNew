class_name BattleMoveChoice_Refactor
extends BattleChoice_Refactor

var move: BattleMove_Refactor

var move_index: int = -1
var target_handler: BattleTarget_Refactor = null

func get_move() -> BattleMove_Refactor:
	if not pokemon or move_index == -1:
		return null
	return pokemon.get_available_moves()[move_index]

func get_targets() -> Array:
	if target_handler:
		return target_handler.selectedTargets
	return []
	
func get_priority() -> int:
	return get_move().get_priority() if get_move() != null else null

func get_main_target():
	if target_handler:
		return target_handler.get_actual_target()
	return null
	
func resolve() -> BattleMoveResult:
	var result := BattleMoveResult.new()
	result.targets = target_handler.selected_targets if target_handler else []

	if result.targets.is_empty():
		result.missed = true
		return result

	# Número de golpes se calcula una vez por ejecución del movimiento
	var num_hits := get_move().get_number_of_hits()
	result.num_hits = num_hits
	print("Num. hits: " + str(num_hits))

	# Recorremos cada target individualmente
	for spot in result.targets:
		var target := spot.get_active_pokemon()

		# Comprobamos si acierta contra este target
		if not AccuracyUtils.check_hit(get_move(), pokemon, target):
			continue  # Falló contra este objetivo, no genera impactos

		# Instanciamos la lógica de la categoría para este target
		var logic: MoveCategoryLogic = get_move().get_category_logic()
		logic.move = get_move()
		logic.user = pokemon
		logic.target = target
		logic.num_hits = num_hits

		for i in num_hits:
			if target.is_fainted():
				break  # No seguir golpeando si ya se debilitó

			var impacts: Array[MoveImpactResult] = await logic.execute_impact()
			result.impact_results.append_array(impacts)

	return result
