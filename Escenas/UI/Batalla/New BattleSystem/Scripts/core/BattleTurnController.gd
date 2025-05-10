extends Node

class_name BattleTurnController

var battle_controller: BattleController
var battle_ui: BattleUI

# El orden final de ejecución de este turno
var turn_order: Array[BattleSpot]

func start_turn_loop():
	while not battle_controller.battle_finished():
		await new_turn()
		await select_actions()
		await execute_turn()
		await end_turn()

	await battle_controller.end_battle()

func new_turn():
	battle_controller.new_turn.emit()
	battle_ui.actions_menu.hide()  # o mostrar algo específico si lo necesitas

func select_actions():
	for spot in battle_controller.get_active_battle_spots():
		var p = spot.get_active_pokemon()
		p.init_turn()
		p.select_action()

		if p.controllable:
			await battle_ui.actions_menu.show_for(p)
			await p.actionSelected
			battle_ui.actions_menu.hide()
		
		print(p.Name + " ha seleccionado: " + p.selectedBattleChoice.type_string())

func execute_turn():
	turn_order = battle_controller.order_pokemon_by_priority()

	for spot in turn_order:
		var p = spot.get_active_pokemon()
		if not p or p.fainted or p.opponent_side.is_defeated():
			continue

		await p.do_action()
		await p.actionFinished

		for s in battle_controller.get_active_battle_spots():
			await s.check_fainted()

		await battle_controller.distribute_experience()

func end_turn():
	# Aquí iría lógica futura de efectos, clima, estados...
	await battle_controller.end_turn()
