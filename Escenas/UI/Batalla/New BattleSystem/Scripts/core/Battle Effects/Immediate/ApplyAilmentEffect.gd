class_name ApplyAilmentEffect
extends ImmediateBattleEffect

var target: BattlePokemon_Refactor
var ailment: Ailment
var _repeated_effect: bool
var is_valid: bool
var _is_blocked_by_other: bool
var show_fail_message : bool

func _init(_target: BattlePokemon_Refactor, _ailment: Ailment, _show_fail_message = true):
	target = _target
	ailment = _ailment
	show_fail_message = _show_fail_message
	check_is_valid()

func apply():
	if check_is_valid() and ailment.effect:
		BattleEffectController.add_pokemon_effect(target, ailment.get_effect())
		if ailment.is_persistent:
			target.set_status(ailment)

func visualize(ui: BattleUI_Refactor):
	if is_valid:
		await ui.show_start_ailment_message(target, ailment)
		if ailment.is_persistent:
			target.status_changed.emit()
	elif show_fail_message:
		await ui.show_already_ailment_message(target, ailment, ailment.is_persistent and target.status != ailment)  #  "¡X ya está paralizado! / ¡Pero falló!"
		

func check_is_valid():
	# El efecto ya está presente (solo relevante si no es persistente)
	_repeated_effect = BattleEffectController.has_effect_for(target, ailment.get_effect() if ailment.effect != null else null)

	# ¿El Pokémon ya tiene otro estado persistente incompatible?
	_is_blocked_by_other = ailment.is_persistent and target.status != null and target.status != ailment

	# ¿Se puede aplicar?
	is_valid = not _repeated_effect and not _is_blocked_by_other
	return is_valid
