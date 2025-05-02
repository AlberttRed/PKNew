extends Node2D
class_name BattleScene

@onready var battle_controller: BattleController_Refactor = $BattleController
@onready var battle_ui: BattleUI_Refactor = $BattleUI

# Inicia un nuevo combate con los participantes y reglas especificadas.
# Prepara ambos lados, aplica reglas, y sincroniza con la UI.
func start_battle(player_participants: Array, enemy_participants: Array, rules: BattleRules):
	# Crea y configura el controlador
	battle_controller.setup_sides(player_participants, enemy_participants, rules)
	battle_ui.setup_for_sides(battle_controller.player_side, battle_controller.enemy_side, rules)
	await battle_controller.start_battle()
