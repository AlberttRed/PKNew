extends Node

class_name BattleController_Refactor

signal battle_started
signal battle_ended

var ui: BattleUI_Refactor
@onready var turn_controller: BattleTurnController = $TurnController
#var animation_controller: BattleAnimationControllerRefactor
#var effect_manager: BattleEffectPhaseManagerRefactor

var rules: BattleRules
var participants: Array = []
var player_side: BattleSide_Refactor
var enemy_side: BattleSide_Refactor
var sides: Array[BattleSide_Refactor]

var finished := false

func _ready():
	# Este método puede quedar vacío si se usa start_battle() desde BattleScene
	pass

# Configura los dos BattleSide con sus participantes y reglas
func setup_sides(player_participants: Array[BattleParticipant_Refactor], enemy_participants: Array[BattleParticipant_Refactor], rules: BattleRules):

	var player_side = BattleSide_Refactor.new(BattleSide_Refactor.Types.PLAYER)
	for p in player_participants:
		player_side.add_participant(p)
	player_side.prepare_for_battle(rules)
	
	var enemy_side = BattleSide_Refactor.new(BattleSide_Refactor.Types.ENEMY)
	for p in enemy_participants:
		enemy_side.add_participant(p)
	enemy_side.prepare_for_battle(rules)
	
	self.player_side = player_side
	self.enemy_side = enemy_side
	self.sides = [player_side, enemy_side]
	assign_opponent_sides()

	self.rules = rules
	
func assign_active_pokemons_to_spots():
	var player_actives = player_side.get_active_pokemons()
	var enemy_actives = enemy_side.get_active_pokemons()

	var player_spots:Array[BattleSpot_Refactor] = ui.get_player_spots_for_mode(rules.mode)
	var enemy_spots:Array[BattleSpot_Refactor] = ui.get_enemy_spots_for_mode(rules.mode)

	for i in player_actives.size():
		var spot := player_spots[i]
		spot.load_active_pokemon(player_actives[i], rules)
		spot.side = player_side
		player_side.battle_spots.append(spot)

	for i in enemy_actives.size():
		var spot := enemy_spots[i]
		spot.load_active_pokemon(enemy_actives[i], rules)
		spot.side = enemy_side
		enemy_side.battle_spots.append(spot)

	# Ajustar visualmente la posición de los spots
	ui.position_battlespots_for_mode(rules.mode)

func start_battle() -> void:
	ui.visible = true  # Si estaba oculto por defecto
	turn_controller.battle_controller = self
	print("Combate iniciado (test)")
	await play_intro_sequence()
	await turn_controller.start_turn_loop()
	
func play_intro_sequence():
	var player_pokemon = player_side.get_active_pokemons()
	var enemy_pokemon = enemy_side.get_active_pokemons()
	var player_trainers = player_side.get_trainer_names()
	var enemy_trainers = enemy_side.get_trainer_names()

	var intro_messages = ui.message_controller.get_intro_messages(
		rules,
		player_pokemon,
		enemy_pokemon,
		player_trainers,
		enemy_trainers
	)

	for msg in intro_messages:
		await show_message_from_dict(msg)
	

		# Opcional: insertar animaciones si lo necesitas más adelante
		# if msg.type == "send_out_enemy":
		#     await enemy_side.play_entry_animation(enemy_pokemon)
		# elif msg.type == "send_out_player":
		#     await player_side.play_entry_animation(player_pokemon)

	# Aquí podrías activar el menú o iniciar la siguiente fase del combate
	ui.actions_menu.show()
	

func get_active_battle_spots() -> Array[BattleSpot_Refactor]:
	var spots: Array[BattleSpot_Refactor] = []

	for side:BattleSide_Refactor in [player_side, enemy_side]:
		for spot:BattleSpot_Refactor in side.battle_spots:
			if spot.pokemon and not spot.pokemon.is_fainted():
				spots.append(spot)

	return spots

func assign_opponent_sides():
	if sides.size() != 2:
		push_warning("assign_opponent_sides() requiere exactamente dos lados.")
		return

	sides[0].opponent_side = sides[1]
	sides[1].opponent_side = sides[0]

func battle_finished() -> bool:
	# Lógica real pendiente
	return false

# Manda el mensaje a mostrar al MessageBox según el tipo de mensaje devuleto por el MessageController
func show_message_from_dict(msg: Dictionary) -> void:
	match msg.type:
		"input":
			await ui.message_box.show_input(msg.text)
		"wait":
			await ui.message_box.show_wait(msg.text, msg.get("wait_time", 1.0))
		"no_close":
			await ui.message_box.show_no_close(msg.text)

func get_message_controller() -> BattleMessageController_Refactor:
	return ui.message_controller


#func init_battle():
	## Configura elementos iniciales, como UI, animaciones de entrada, etc.
	#effect_manager.update_active_pokemon_effects(get_active_pokemon())
	#ui.setup_participants(participants)
	## Mostrar sprites, barras, etc.
	## Opcional: mostrar pokéballs, habilidades, clima...
#
#func loop_turns():
	#while not finished:
		#await effect_manager.apply_turn_start()
#
		#var turn := BattleTurn.new(get_active_pokemon())
		#await turn.collect_choices()
		#await turn.execute()
#
		#await effect_manager.apply_turn_end()
		#await check_victory_conditions()
#
#func get_active_pokemon() -> Array:
	#var actives = []
	#for participant in participants:
		#actives += participant.get_active_pokemons()
	#return actives
#
#func check_victory_conditions():
	## Implementa la lógica para finalizar el combate
	## Si un equipo no tiene más pokémon, marca la batalla como finalizada
	#if false:  # reemplaza con condición real
		#finished = true
