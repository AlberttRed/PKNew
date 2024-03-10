extends "res://Scripts/CharacterController.gd"

@onready var rayEvents: RayCast2D = $RayCastEvents
@onready var trainer = $Trainer #get_node("Trainer")


func _ready():
	super._ready()
	GLOBAL.PLAYER = self
	$Sprite.texture = GAME_DATA.player_default_sprite
	anim_state.travel("Walk")
	SIGNALS.PLAYER.connect("collided", Callable(self, "interact_at_collide"))
	#SIGNALS.PLAYER.connect("moved_signal", Callable(self, "checkEncounterType"))
	moved_signal.connect(Callable(self, "checkEnteredTile"))
	turned_signal.connect(Callable(self, "checkEnteredTile"))
	GAME_DATA.party = trainer.get_children()
	
func _physics_process(delta):
	
	if move_state == MoveState.TURNING:
		return
	elif is_moving == false:
		process_player_movement_input()
	elif input_direction != Vector2.ZERO:
		if running:
			anim_state.travel("Run")
		else:
			anim_state.travel("Walk")
		move(delta)
	else:
		anim_state.travel("Idle")
		is_moving = false

func get_next_event(desired_step = CONST.FacingInput[facing_direction] * TILE_SIZE / 2):
	rayEvents.target_position = desired_step
	rayEvents.force_raycast_update()
	
	if rayEvents.is_colliding():
		next_event = rayEvents.get_collider()
	else:
		next_event = null

func interact():
	set_running(false)
	get_next_event()
	if next_event != null and next_event.Interact:
		stop_movement()
		GLOBAL.SCENE_MANAGER.exec_event(next_event)
		#next_event.exec()
		await next_event.finished
		#await SIGNALS.EVENT.finished
		
func interact_at_collide():
	set_running(false)
	get_next_event()
#	if next_event != null:
#		print(next_event.name)
	if next_event != null and (next_event.PlayerTouch and !next_event.Through):

		stop_movement()
		GLOBAL.SCENE_MANAGER.exec_event(next_event)
		#next_event.exec()
		await next_event.finished
		#await SIGNALS.EVENT.finished	

func _input(event):
	if event.is_action_pressed("ui_accept") and !GUI.isVisible():
		print("A")
#		print(GLOBAL.actual_map.map_connections_list[0].active_tilemap.position)
#		print(GLOBAL.actual_map.map_connections_list[0].global_position)
		
		
		#trainer.print_pokemon_team()
#		for p in GLOBAL.actual_map.get_node("WildEncounters/MapAreaEncounter").pokemonEncounterList:
#			print(str(p.pkmn_id))
		#e.remote_move([CONST.MOVE_COMMANDS.UP,CONST.MOVE_COMMANDS.UP,CONST.MOVE_COMMANDS.UP,CONST.MOVE_COMMANDS.UP,CONST.MOVE_COMMANDS.UP,CONST.MOVE_COMMANDS.UP,CONST.MOVE_COMMANDS.RIGHT,CONST.MOVE_COMMANDS.RIGHT,CONST.MOVE_COMMANDS.RIGHT,CONST.MOVE_COMMANDS.RIGHT])
		#print_orphan_nodes()
		#print(str(trainer.get_child(0).base.type_a.Name))
		interact()
#		var move = preload("res://Scripts/Event/Event Commands/cmd_move.gd").new()
#		GLOBAL.actual_map.add_child(move)
#		move.Target = GLOBAL.actual_map.get_node("Eventos").get_node("Chica2").get_path()
#		#move.move_commands = [move.Directions.RIGHT]
#		move.force_exec([move.Directions.RIGHT])

		#FORCAR MOVIMENT EVENTO
#		var move : RemoteMovement = RemoteMovement.new(GLOBAL.actual_map.get_node("Eventos").get_node("Chica2"))
#		GLOBAL.actual_map.add_child(move)
#		move.move([move.Directions.RIGHT])
#		await move.movement_finished
#		GLOBAL.actual_map.remove_child(move)
	elif event.is_action_pressed("ui_cancel") and !GUI.isVisible() && !eventOn:
		print("B")
		set_running(true)
	elif event.is_action_released("ui_cancel") and !GUI.isVisible():
		set_running(false)
#		GUI.show_msg("Hola que tal em dic Albert, l'altre dia vaig anar a comprar el pa i la veritat es que mec.", null, null, null, [], true)
#		await GUI.input
	elif event.is_action_pressed("ui_start") and !GUI.isVisible():
		GUI.show_menu()

func set_running(state):
	running = state
	if !surfing:
		if state:
			if is_moving:
				$Sprite.texture = GAME_DATA.player_run_sprite
				walk_speed = 8.0
		else:
			$Sprite.texture = GAME_DATA.player_default_sprite
			walk_speed = 4.0
			
func move(delta):
	if Input.is_action_pressed("ui_cancel") and !GUI.isVisible() && !eventOn:
		set_running(true)
	super.move(delta)
	
	
func process_player_movement_input():
	super.process_player_movement_input()
	if input_direction == Vector2.ZERO:
		set_running(false)

func checkEnteredTile():
	var entered_tile = get_tile(GLOBAL.actual_map.active_tilemap, 0, global_position)
	if entered_tile != null:
		if entered_tile.get_custom_data("EncounterTile"):
			var area_id = entered_tile.get_custom_data("EncounterArea")
			var encounterArea = GLOBAL.actual_map.get_encounterArea(area_id)
			if encounterArea != null:
				if encounterArea.tryEncounter():
					stop_movement()
					encounterArea.getPokemonEncounter()
					
func set_through(state):
	#Capa Player
	set_collision_layer_value(1, !state)
	set_collision_mask_value(1, !state)
	
	#Capa Map area
	set_collision_mask_value(2, !state)

					
