class_name MultiHitEffect
extends ImmediateBattleEffect

var user: BattlePokemon_Refactor
var target: BattlePokemon_Refactor
var move: BattleMove_Refactor
var num_hits: int

var sub_effects: Array[ImmediateBattleEffect] = []

func _init(_user, _target, _move, _num_hits):
	user = _user
	target = _target
	move = _move
	num_hits = _num_hits

	for i in num_hits:
		if target.is_fainted():
			break

		var logic = move.get_category_logic()
		logic.move = move
		logic.user = user
		logic.target = target
		logic.num_hits = num_hits

		var effects: Array[ImmediateBattleEffect] = logic.execute()

		for e in effects:
			# Evitar que cada golpe muestre el mensaje de efectividad individualmente
			if e is DamageEffect:
				e.show_effectiveness = false
			sub_effects.append(e)

func apply():
	for effect in sub_effects:
		effect.apply()

func visualize(ui:BattleUI_Refactor):
	for effect in sub_effects:
		await effect.visualize(ui)

	if num_hits > 1:
		await ui.show_multi_hit_message(num_hits)

	# Mostrar mensaje de efectividad (solo una vez, si aplica)
	#var dynamic_array: Array = sub_effects
	#var first_effective = dynamic_array.find(func(e):
		#return e is DamageEffect and e.effectiveness != 1.0
	#)
	var first_effective = (sub_effects as Array).find(func(e):
		return e is DamageEffect and e.effectiveness != 1.0
	)

	if first_effective != -1:
		var eff := (sub_effects[first_effective] as DamageEffect)
		ui.show_effectiveness_message(eff)
