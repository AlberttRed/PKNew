class_name BattleTarget_Refactor
extends RefCounted

signal request_manual_selection(candidates: Array[BattleSpot_Refactor])
signal target_selected

enum TYPE {
	NONE, ESPECIFICO, YO_PRIMERO, ALIADO,
	BASE_PLAYER, USER_OR_ALLY, BASE_ENEMY,
	USER, RANDOM_ENEMY, ALL_OTHER, SELECCIONAR,
	ENEMIES, ALL_FIELD, PLAYERS, ALL_POKEMON
}

var move: BattleMove_Refactor
var type: TYPE:
	get: return move.base_data.get_target_id()

var selected_targets: Array[BattleSpot_Refactor] = []
var _targetCursor: int = -1

func _init(move: BattleMove_Refactor):
	self.move = move

func get_actual_target() -> BattleSpot_Refactor:
	if selected_targets.is_empty() or _targetCursor >= selected_targets.size():
		return null
	return selected_targets[_targetCursor]

func nextTarget() -> bool:
	_targetCursor += 1
	return get_actual_target() != null

func select_targets() -> void:
	selected_targets.clear()
	_targetCursor = -1

	match type:
		TYPE.SELECCIONAR:
			if move.pokemon.controllable:
				await await_manual_selection(_get_selectable_enemy_spots())
			else:
				selected_targets.append(_get_random_enemy_spot())

		TYPE.USER:
			selected_targets.append(move.pokemon.battle_spot)

		TYPE.ENEMIES:
			selected_targets = _get_enemy_spots()

		TYPE.PLAYERS:
			selected_targets = _get_player_spots()

		# Otros tipos según necesidad...

func set_manual_target(spot: BattleSpot_Refactor) -> void:
	selected_targets = [spot]
	_targetCursor = 0
	emit_signal("target_selected")

# --------------------------------------
# Métodos auxiliares

func _get_enemy_spots() -> Array[BattleSpot_Refactor]:
	return move.pokemon.get_opponent_side().battle_spots.filter(
		func(s): return s.has_active_pokemon()
	)

func _get_player_spots() -> Array[BattleSpot_Refactor]:
	return move.pokemon.side.battle_spots.filter(
		func(s): return s.has_active_pokemon()
	)

func _get_selectable_enemy_spots() -> Array[BattleSpot_Refactor]:
	var all := _get_enemy_spots()
	return all if not all.is_empty() else []
	
func _get_random_enemy_spot() -> BattleSpot_Refactor:
	var enemies = _get_enemy_spots()
	if enemies.is_empty(): return null
	return enemies[randi() % enemies.size()]
	
func await_manual_selection(candidates: Array[BattleSpot_Refactor]) -> void:
	if candidates.size() == 1:
		set_manual_target(candidates[0])
	else:
		emit_signal("request_manual_selection", candidates)
		await target_selected
	
func get_candidate_spots() -> Array[BattleSpot_Refactor]:
	match type:
		TYPE.SELECCIONAR:
			return _get_selectable_enemy_spots()
		#TYPE.USER_OR_ALLY:
			#return _get_user_or_ally_spots()
		# Otros tipos si quieres extenderlo...
		_:
			return []
