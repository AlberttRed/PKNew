extends MoveCategoryLogic
class_name MoveCategoryDamageLower

func execute_impact():
	push_warning("MoveCategoryDamageLower not implemented")
	return []  as Array[MoveImpactResult]
	#if move.inflicts_damage():
		#await move.calculate_damage()
		#await move.do_damage()
	#await move.apply_stat_changes_to_target()
