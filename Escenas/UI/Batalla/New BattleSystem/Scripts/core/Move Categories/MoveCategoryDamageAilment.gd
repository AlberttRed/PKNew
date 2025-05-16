extends MoveCategoryLogic
class_name MoveCategoryDamageAilment

func execute_impact():
	push_warning("MoveCategoryDamageAilment not implemented")
	return []  as Array[MoveImpactResult]
	#if move.inflicts_damage():
		#await move.calculate_damage()
		#await move.do_damage()
	#if move.causes_ailment():
		#await move.cause_ailment()
