class_name BattleMoveResult
extends RefCounted

var targets: Array[BattleSpot_Refactor] = []
var impact_results: Array[MoveImpactResult] = []
var missed: bool = false
var num_hits: int = 1

#func get_damage_results_for(target: BattlePokemon_Refactor) -> Array[MoveImpactResult.Damage]:
	#var results: Array[MoveImpactResult.Damage] = []
	#for impact in impact_results:
		#if impact is MoveImpactResult.Damage and impact.target == target:
			#results.append(impact)
	#return results
	#
func add_impact(impact: MoveImpactResult) -> void:
	impact_results.append(impact)

func inflicts_damage() -> bool:
	return impact_results.any(func(impact): return impact is MoveImpactResult.Damage)
	
func is_multi_hit():
	return num_hits > 1

func get_impact_results_for(target: BattlePokemon_Refactor) -> Array[MoveImpactResult]:
	return impact_results.filter(func(impact):
		return impact.target == target
	)

func is_super_effective_for(target: BattlePokemon_Refactor) -> bool:
	var damage:MoveImpactResult.Damage = impact_results.filter(func(impact):
		return impact is MoveImpactResult.Damage and impact.target == target
	).front()
	return damage != null and damage.is_super_effective()


func is_not_very_effective_for(target: BattlePokemon_Refactor) -> bool:
	var damage:MoveImpactResult.Damage = impact_results.filter(func(impact):
		return impact is MoveImpactResult.Damage and impact.target == target
	).front()
	return damage != null and damage.is_not_very_effective()


func is_ineffective_for(target: BattlePokemon_Refactor) -> bool:
	var damage:MoveImpactResult.Damage = impact_results.filter(func(impact):
		return impact is MoveImpactResult.Damage and impact.target == target
	).front()
	return damage != null and damage.is_ineffective()
