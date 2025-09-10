class_name ApplyDamageEffect
extends ImmediateBattleEffect

var user: BattlePokemon_Refactor
var target: BattlePokemon_Refactor
var move: BattleMove_Refactor
var damage:DamageEffect
var show_effectiveness:bool = true

func _init(_user: BattlePokemon_Refactor, _target: BattlePokemon_Refactor, _move: BattleMove_Refactor):
	user = _user
	target = _target
	move = _move

func apply():
	damage = move.calculate_damage(target)
	damage.apply()

func visualize(ui: BattleUI_Refactor):
	await damage.visualize(ui)
	
	if damage.is_critical:
		await ui.show_critical_hit_message()

	if show_effectiveness:
		await ui.show_effectiveness_message(damage)
