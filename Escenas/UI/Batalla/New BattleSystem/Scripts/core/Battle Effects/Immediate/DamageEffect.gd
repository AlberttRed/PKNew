class_name DamageEffect
extends ImmediateBattleEffect

var user: BattlePokemon_Refactor
var target: BattlePokemon_Refactor
var move: BattleMove_Refactor
var amount: int

var is_critical := false
var effectiveness := 1.0
var show_effectiveness := true

func _init(_user, _target, _move, _amount):
	user = _user
	target = _target
	move = _move
	amount = _amount

func apply():
	if !is_ineffective():
		target.take_damage(self)

func visualize(ui:BattleUI_Refactor):
	if !is_ineffective():
		await target.battle_spot.play_hit_animation()
		await target.battle_spot.apply_damage(amount)

		if is_critical:
			await ui.show_critical_hit_message()

	if show_effectiveness:
		await ui.show_effectiveness_message(self)
			
func is_super_effective() -> bool:
	return effectiveness > 1.0

func is_not_very_effective() -> bool:
	return effectiveness > 0.0 and effectiveness < 1.0

func is_ineffective() -> bool:
	return effectiveness == 0.0
