extends Node

class_name BattleTurnController

var battle_controller: BattleController_Refactor

var current_turn := 0
var collected_choices: Array[BattleChoice_Refactor] = []

func start_turn_loop():
	while not battle_controller.battle_finished():
		await new_turn()
		await select_actions()
		await execute_turn()
		await end_turn()

	await battle_controller.end_battle()

func new_turn():
	current_turn += 1
	#battle_controller.new_turn.emit()
	#battle_ui.actions_menu.hide()  # o mostrar algo específico si lo necesitas

func select_actions():
	collected_choices.clear()
	# Recorremos todos los BattleSpots activos en ambos lados del combate
	for spot:BattleSpot_Refactor in battle_controller.get_active_battle_spots():
		var p:BattlePokemon_Refactor = spot.get_active_pokemon()
		p.init_turn()

		if p.controllable:
			var choice = await battle_controller.ui.show_action_menu_for(p)
			p.selectedBattleChoice = choice
		else:
			var participant = p.participant  # o como lo tengas enlazado
			p.selectedBattleChoice = await participant.decide_action_for(p)
		if p.selectedBattleChoice != null:
			collected_choices.append(p.selectedBattleChoice)
			
func execute_turn():
	var ordered_choices:Array[BattleChoice_Refactor] = order_choices(collected_choices)
	var results: Dictionary = {} # key: BattleChoice_Refactor, value: BattleMoveResult
	
	#Calculamos y resolvemos las acciones seleccionadas por cada pokémon activo
	for choice:BattleChoice_Refactor in ordered_choices:
		if choice.pokemon.is_fainted():
			return
		var move_result = await choice.resolve()
		results[choice] = move_result
	
	print_turn_debug_log(ordered_choices, results)
	
	# Mostrar animaciones y efectos tras resolver todo
	for choice in ordered_choices:
		if results.has(choice):
			await handle_result(choice, results[choice])

func order_choices(battle_choices: Array[BattleChoice_Refactor]) -> Array[BattleChoice_Refactor]:
	battle_choices.sort_custom(_sort_choices)
	print(">>> Orden de ejecución:")
	for choice:BattleChoice_Refactor in battle_choices:
		var pkmn_name = choice.pokemon.get_name()
		var move_name = choice.get_move().get_name() if choice.get_move() != null else "Otra acción"
		print("- %s usará %s (velocidad: %d)" % [
			pkmn_name, move_name, choice.pokemon.get_speed()
		])
	return battle_choices
	


func _sort_choices(a: BattleChoice_Refactor, b: BattleChoice_Refactor) -> bool:
	# 1. Prioridad
	if a.get_priority() != b.get_priority():
		return a.get_priority() > b.get_priority()

	# 2. Velocidad
	var speed_a = a.pokemon.get_speed()
	var speed_b = b.pokemon.get_speed()

	if speed_a != speed_b:
		return speed_a > speed_b

	# 3. Desempate aleatorio
	return randi() % 2 == 0

func handle_result(choice: BattleChoice_Refactor, result) -> void:
	if choice is BattleMoveChoice_Refactor:
		await battle_controller.ui.result_display.display_move_result(result, choice)
		#await handle_move_result(choice, result)

	# elif choice is BattleSwitchChoice_Refactor:
	#	await handle_switch_result(choice, result)

	# BattleItemChoice:
	# 	await handle_item_result(choice, result)

	# BattleRunChoice:
	# 	await handle_run_result(choice, result)

	else:
		push_warning("handle_result: tipo de choice no reconocido o aún no implementado.")
#
#func handle_move_result(choice: BattleMoveChoice_Refactor, result: BattleMoveResult) -> void:
	#var user = choice.pokemon
	#var move = choice.get_move()
	#var message_controller:= battle_controller.get_message_controller()
#
	#var used_msg := message_controller.get_used_move_message(move, user)
	#await battle_controller.show_message_from_dict(used_msg)
#
	## ⚠️ Animación general del movimiento (comentado por ahora)
	## await animation_controller.play_move_animation(user, move, result.targets)
#
	#if result.missed:
		#var missed_target := result.targets[0].get_active_pokemon()
		#var msg:Dictionary = message_controller.get_failed_move_message(user)
		#await battle_controller.show_message_from_dict(msg)
		#return
#
#
	#for spot:BattleSpot_Refactor in result.targets:
		#var pokemon := spot.get_active_pokemon()
		#var dmg_list = result.get_damage_results_for(pokemon)#result.damage_results.get(pokemon, [])
#
		#for dmg in dmg_list:
			## ⚠️ Animación de golpe (se deberá mover al AnimationController)
			#await spot.play_hit_animation()
#
#
			## ⚠️ Reducción visual de HP 
			#await spot.apply_damage(dmg)
#
			## Mostrar mensajes (eficacia, crítico...)
			#for msg in message_controller.get_damage_result_messages(choice, dmg, pokemon):
				#await battle_controller.show_message_from_dict(msg)
#
		#if dmg_list.size() > 1:
			#var multi_hit_msg := message_controller.get_multi_hit_message(dmg_list.size())
			#await battle_controller.show_message_from_dict(multi_hit_msg)
#
		#if pokemon.get_hp() == 0:
			#var faint_msg := message_controller.get_faint_message(pokemon)
			#await battle_controller.show_message_from_dict(faint_msg)
#
			## ⚠️ Animación de debilitamiento (comentado por ahora)
			## await animation_controller.play_faint_animation(pokemon)


func end_turn():
	pass
	# Aquí iría lógica futura de efectos, clima, estados...
	#await battle_controller.end_turn()

func print_turn_debug_log(choices: Array[BattleChoice_Refactor], results: Dictionary) -> void:
	for choice in choices:
		if choice is BattleMoveChoice_Refactor and results.has(choice):
			var result: BattleMoveResult = results[choice]
			var user := choice.pokemon.get_name()
			var move = choice.get_move().get_name()

			if result.missed:
				var missed_target := result.targets[0].get_active_pokemon().get_name()
				print("%s usará %s contra %s pero fallará." % [user, move, missed_target])
			else:
				# Agrupamos por target
				var grouped := {}
				for impact in result.impact_results:
					var t := impact.target
					if not grouped.has(t):
						grouped[t] = { "damage": 0, "healing": 0 }
					
					if impact is MoveImpactResult.Damage:
						grouped[t].damage += impact.amount
					elif impact is MoveImpactResult.Heal:
						grouped[t].healing += impact.amount

				# Mostrar resumen por objetivo
				for target:BattlePokemon_Refactor in grouped.keys():
					var tname := target.get_name()
					var entry = grouped[target]
					if entry.damage > 0:
						print("%s usará %s contra %s e infligirá %d de daño." % [user, move, tname, entry.damage])
					if entry.healing > 0:
						print("%s usará %s y curará %d PS a %s." % [user, move, entry.healing, tname])
