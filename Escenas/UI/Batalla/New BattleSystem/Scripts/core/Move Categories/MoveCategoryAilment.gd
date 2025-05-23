class_name MoveCategoryAilment
extends MoveCategoryLogic

func execute() -> Array[ImmediateBattleEffect]:
	var effects: Array[ImmediateBattleEffect] = []

	if move.get_ailment() and randf() < move.get_ailment_chance():
		effects.append(ApplyAilmentEffect.new(target, move.get_ailment()))

	return effects
