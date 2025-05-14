class_name BattleMove_Refactor
extends RefCounted

enum DamageClass {
	STATUS = 1,
	PHYSIC = 2,
	SPECIAL = 3	
}

var base_data: MoveInstance
var pokemon: BattlePokemon_Refactor

func _init(_base_data: MoveInstance, _pokemon: BattlePokemon_Refactor):
	self.base_data = _base_data
	self.pokemon = _pokemon

func get_name() -> String:
	return base_data.Name

func get_type() -> Type:
	return base_data.type as Type

func get_type_name() -> String:
	return base_data.type.Name

func get_damage_class() -> DamageClass:
	return base_data.damage_class as DamageClass

func is_physic_category():
	return get_damage_class() == DamageClass.PHYSIC

func is_special_category():
	return get_damage_class() == DamageClass.SPECIAL
	
func is_status_category():
	return get_damage_class() == DamageClass.STATUS

func get_pp() -> int:
	return base_data.pp_actual

func get_total_pp() -> int:
	return base_data.pp

func get_power() -> int:
	return base_data.power

func get_accuracy() -> int:
	return base_data.accuracy

func is_depleted() -> bool:
	return base_data.pp_actual <= 0

func get_priority() -> int:
	return base_data.priority

func get_number_of_hits() -> int:
	var min_hits = get_min_hits()
	var max_hits = get_max_hits()

	if min_hits >= max_hits:
		return min_hits # por seguridad, o ataques normales

	# Para el caso específico de 2 a 5 golpes, usamos distribución oficial
	if min_hits == 2 and max_hits == 5:
		var roll = randi_range(1, 100)
		if roll <= 35:
			return 2
		elif roll <= 70:
			return 3
		elif roll <= 85:
			return 4
		else:
			return 5

	# En otros casos (ej: 2–3 golpes), elegimos al azar dentro del rango
	return randi_range(min_hits, max_hits)


func is_multi_hit() -> bool:
	return base_data.get_max_hits() > 1
	
func get_max_hits() -> int:
	return base_data.get_max_hits()

func get_min_hits() -> int:
	return base_data.get_min_hits()

func get_critical_rate() -> int:
	return base_data.get_critical_rate()

# Placeholder para más adelante
func apply(target: BattleSpot_Refactor):
	pass
