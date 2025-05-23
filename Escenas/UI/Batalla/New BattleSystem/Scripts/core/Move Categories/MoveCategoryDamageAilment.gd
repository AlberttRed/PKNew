class_name MoveCategoryDamageAilment
extends MoveCategoryLogic

func execute() -> Array[ImmediateBattleEffect]:
	var effects: Array[ImmediateBattleEffect] = []

	# Efecto de daño
	var damage_effect := move.calculate_damage(target)
	effects.append(damage_effect)

	# Efecto de estado (si hay posibilidad de aplicar un ailment)
	if !damage_effect.is_ineffective() and move.get_ailment() and 0 < move.get_ailment_chance():
		var ailment_effect := ApplyAilmentEffect.new(target, move.get_ailment(), false)
		if ailment_effect.is_valid:
			effects.append(ailment_effect)

	return effects
