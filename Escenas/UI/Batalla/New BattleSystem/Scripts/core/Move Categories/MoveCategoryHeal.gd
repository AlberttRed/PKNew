extends MoveCategoryLogic
class_name MoveCategoryHeal

func execute_impact() -> Array[MoveImpactResult]:
	return [move.calculate_healing(user)]
