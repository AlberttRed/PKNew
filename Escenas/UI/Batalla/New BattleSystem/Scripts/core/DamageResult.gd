class_name DamageResult
extends RefCounted

var damage: int = 0
var is_critical: bool = false
var effectiveness: float = 1.0

func _init(damage: int, is_critical: bool, effectiveness: float):
	self.damage = damage
	self.is_critical = is_critical
	self.effectiveness = effectiveness

func is_super_effective() -> bool:
	return effectiveness > 1.0

func is_not_very_effective() -> bool:
	return effectiveness > 0.0 and effectiveness < 1.0

func is_ineffective() -> bool:
	return effectiveness == 0.0
