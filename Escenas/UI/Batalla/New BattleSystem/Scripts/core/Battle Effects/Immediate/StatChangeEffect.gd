class_name StatChangeEffect
extends ImmediateBattleEffect

var target: BattlePokemon_Refactor

var stats_changes_list: Dictionary[StatTypes.Stat, int]

var _applied: bool = false

func _init(_target:BattlePokemon_Refactor, _stats_changes_list:Dictionary[StatTypes.Stat, int]):
	target = _target
	stats_changes_list = _stats_changes_list

func apply() -> void:
	for stat in stats_changes_list:
		var amount = stats_changes_list[stat]
		if amount > 0:
			_applied = target.stat_stages.increase(stat, amount)
		else:
			_applied = target.stat_stages.decrease(stat, abs(amount))

func visualize(ui: BattleUI_Refactor):
	if not _applied:
		return  # Nada que mostrar
		
	# TO DO ANIMACIÓ

	for stat in stats_changes_list:
		var amount = stats_changes_list[stat]
		await ui.show_stat_stage_change_message(target, stat, amount)
