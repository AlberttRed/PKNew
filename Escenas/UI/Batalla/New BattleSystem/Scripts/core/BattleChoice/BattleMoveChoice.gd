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

	var target := result.targets[0].get_active_pokemon() # asumimos 1v1 por ahora

	# Calcular si acierta el movimiento (una vez para todo el movimiento)
	if not AccuracyUtils.check_hit(get_move(), pokemon, target):
		result.missed = true
		return result

	# Calcular número de golpes (1 por defecto, o 2-5 si multigolpe)
	var num_hits := get_move().get_number_of_hits() # este método lo puedes adaptar luego
	result.num_hits = num_hits
	print("Num. hits: " + str(num_hits))
	var dmg_list: Array[DamageResult] = []
	for i in num_hits:
		if target.is_fainted():
			break

		var dmg := DamageCalculator_Gen5.calculate(get_move(), pokemon, target)
		dmg_list.append(dmg)

	result.damage_results[target] = dmg_list
	return result
