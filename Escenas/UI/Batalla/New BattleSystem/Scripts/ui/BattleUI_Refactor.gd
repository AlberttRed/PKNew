extends Control

class_name BattleUI_Refactor

@onready var message_controller:BattleMessageController_Refactor = $MessageController
@onready var field_ui:FieldUI = $FieldUI
@onready var party_ui = $PartyUI
@onready var actions_menu = $ActionsMenu
@onready var message_box:MessageBox = $MessageBox
@onready var moves_menu = $MovesMenu
@onready var target_selector_ui = $TargetSelectorUI

func _ready() -> void:
	visible = false

func show_trainer_sprites():
	$FieldUI/PlayerBase/TrainerA.visible = true
	$FieldUI/EnemyBase/TrainerA.visible = true  # O TrainerB si hay más de uno
	# Mostrar los sprites de los entrenadores en pantalla

func show_enemy_pokemon(pokemons: Array[BattlePokemon_Refactor], rules: BattleRules):
	if pokemons.size() >= 1:
		var spot_a: BattleSpot_Refactor = $FieldUI/EnemyBase/PokemonSpotA
		spot_a.load_active_pokemon(pokemons[0], rules)

	if pokemons.size() >= 2:
		var spot_b: BattleSpot_Refactor = $FieldUI/EnemyBase/PokemonSpotB
		spot_b.load_active_pokemon(pokemons[1], rules)
	# Mostrar el sprite del Pokémon enemigo

func show_player_pokemon(pokemons: Array[BattlePokemon_Refactor], rules: BattleRules):
	if pokemons.size() >= 1:
		$FieldUI/PlayerBase/PokemonSpotA.load_active_pokemon(pokemons[0], rules)
	if pokemons.size() >= 2:
		$FieldUI/PlayerBase/PokemonSpotB.load_active_pokemon(pokemons[1], rules)
	# Mostrar el sprite del Pokémon del jugador

func show_enemy_hp_bar(pokemons: Array[BattlePokemon_Refactor]):
	if pokemons.size() >= 1:
		$FieldUI/EnemyBase/HPBarA.visible = true
	if pokemons.size() >= 2:
		$FieldUI/EnemyBase/HPBarB.visible = true
	# Mostrar la barra de vida del Pokémon enemigo

func show_player_hp_bar(pokemons: Array[BattlePokemon_Refactor]):
	if pokemons.size() >= 1:
		$FieldUI/PlayerBase/HPBarA.visible = true
	if pokemons.size() >= 2:
		$FieldUI/PlayerBase/HPBarB.visible = true
	# Mostrar la barra de vida del Pokémon del jugador

func get_player_spots_for_mode(mode: int) -> Array[BattleSpot_Refactor]:
	return $FieldUI.get_player_spots_for_mode(mode)

func get_enemy_spots_for_mode(mode: int) -> Array[BattleSpot_Refactor]:
	return $FieldUI.get_enemy_spots_for_mode(mode)

func get_all_spots_for_mode(mode: int) -> Array[BattleSpot_Refactor]:
	return $FieldUI.get_all_spots_for_mode(mode)

func position_battlespots_for_mode(mode: int) -> void:
	$FieldUI.position_battlespots_for_mode(mode)

func show_action_menu_for(pokemon: BattlePokemon_Refactor) -> BattleChoice_Refactor:
	# Mostrar panel de acciones: LUCHAR, POKÉMON, MOCHILA, HUIR
	var choice:BattleChoice_Refactor = await actions_menu.show_for(pokemon)
	choice.pokemon = pokemon  # Importante: establecer el Pokémon que realiza la acción

	# Si no es LUCHAR, devolvemos directamente
	if choice is not BattleMoveChoice_Refactor:
		return choice

	# Mostrar el menú de movimientos
	var move_choice:BattleMoveChoice_Refactor = await moves_menu.show_for(pokemon)
	move_choice.pokemon = pokemon  # también aquí, por seguridad

	# Crear el manejador de targets
	var target_handler := BattleTarget_Refactor.new(move_choice.get_move())

	# Conectar la petición de selección manual
	target_handler.request_manual_selection.connect(func(candidates):
		request_target_selection(target_handler)
	)

	# Ejecutar la lógica de selección de targets (manual o automática)
	await target_handler.select_targets()

	# Asignar el handler al BattleChoice
	move_choice.target_handler = target_handler

	return move_choice


func show_moves_menu_for(pokemon: BattlePokemon_Refactor) -> BattleChoice_Refactor:
	return await moves_menu.show_for(pokemon)
	
func hide_action_menu():
	actions_menu.hide()
	
func request_target_selection(target: BattleTarget_Refactor) -> void:
	var candidates = target.get_candidate_spots()

	if candidates.size() == 1:
		target.set_manual_target(candidates[0])
		return

	target_selector_ui.target_chosen.connect(func(spot):
		target.set_manual_target(spot)
	, CONNECT_ONE_SHOT)

	target_selector_ui.show_targets(candidates)


func show_message(text: String):
	pass
	# Mostrar un mensaje en pantalla y esperar la confirmación del jugador

func show_action_menu():
	pass
	# Mostrar el menú de acciones para que el jugador elija su próximo movimiento
