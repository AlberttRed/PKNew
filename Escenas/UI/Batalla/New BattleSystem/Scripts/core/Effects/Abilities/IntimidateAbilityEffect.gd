extends BattleAbilityEffect_Refactor
class_name IntimidateAbilityEffect

func _init():
	scope = Scope.POKEMON

func on_switch_in():
	if source == null or source.owner_side == null:
		return

	#var opponents := BattleController.get_opponents_on_field(source.owner_side)
	#for enemy in opponents:
		#if enemy != null and not enemy.fainted:
			#enemy.modify_stat("attack", -1)
			#await BattleUI.message_box.show_message("¡" + source.display_name + " intimida a " + enemy.display_name + "!")
