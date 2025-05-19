class_name DamageCalculator_Gen5
extends RefCounted

static func calculate(move: BattleMove_Refactor, user: BattlePokemon_Refactor, target: BattlePokemon_Refactor) -> MoveImpactResult:
	var atk = user.get_sp_attack() if move.is_special_category() else user.get_attack()
	var def = target.get_sp_defense() if move.is_special_category() else target.get_defense()
	var level = user.get_level()
	var power = move.get_power()

	# Paso 1: Daño base
	var base = (((2 * level / 5 + 2) * power * atk / def) / 50) + 2

	# Paso 2: STAB
	var stab = 1.5 if move.get_type() == user.get_type1() or move.get_type() == user.get_type2() else 1.0

	# Paso 3: Crítico (x1.5 en Gen 5)
	var is_crit = is_critical_hit(move.get_critical_rate())
	var crit = 1.5 if is_crit else 1.0

	# Paso 4: Efectividad (tu sistema con Resource)
	var effectiveness = TypeEffectivenessUtils.get_multiplier(
		move.get_type(), target.get_type1(), target.get_type2()
	)

	# Paso 5: Variación aleatoria
	var random_factor = randf_range(0.85, 1.0)

	# Paso 6: Daño final
	var total = floor(base * stab * crit * effectiveness * random_factor)
	
	# Encapsulamos el resultado en un objeto MoveImpactResult.Damage
	var result := MoveImpactResult.Damage.new(int(total), is_crit, effectiveness)
	result.user = user
	result.target = target
	
	return result

static func get_crit_chance(stage: int) -> float:
	match clamp(stage, 0, 3):
		0: return 1.0 / 24.0
		1: return 1.0 / 8.0
		2: return 1.0 / 2.0
		_: return 1.0

static func is_critical_hit(stage: int) -> bool:
	return randf() < get_crit_chance(stage)
