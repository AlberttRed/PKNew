extends MoveCategoryLogic
class_name MoveCategoryDamage

func execute_impact() -> Array[MoveImpactResult]:
	return [move.calculate_damage(target)]
