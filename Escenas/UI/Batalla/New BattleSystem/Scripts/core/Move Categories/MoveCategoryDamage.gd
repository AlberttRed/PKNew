class_name MoveCategoryDamage
extends MoveCategoryLogic

func execute() -> Array[ImmediateBattleEffect]:
	return [move.calculate_damage(target)]
