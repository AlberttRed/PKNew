extends CharacterBody2D

class_name CharacterController

signal moving_signal
signal moved_signal
signal turned_signal
signal collision_signal

signal remote_moved_signal
signal remote_turned_signal
signal remote_collided_signal

const LandingDustEffect = preload("res://Objetos/Animaciones/LandingDustEffect.tscn")

@export var walk_speed : float = 4.0
@export var jump_speed : float = 4.0

const TILE_SIZE : int = 32

@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
#@onready var ray: ShapeCast2D = $ShapeCast2D
@onready var rayTiles: RayCast2D = $RayCastTiles
@onready var sprite:Sprite2D = $Sprite

enum MoveState { IDLE, TURN, TURNING, WALK, WALKING, RUN, RUNNING, JUMP, JUMPING, COLLIDE }
enum FacingDirection { LEFT, RIGHT, UP, DOWN }
enum OppositeFacingDirection { RIGHT, LEFT, DOWN, UP }


var move_state = MoveState.IDLE
var facing_direction = FacingDirection.DOWN
var opposite_facing_direction = FacingDirection.UP

var initial_position = Vector2(0, 0)
var input_direction = Vector2(0, 0)
var is_moving = false
var percent_moved_to_next_tile = 0.0

var next_tile = null
var actual_tile = null

var next_event = null

var continued: bool = false
var jumping: bool = false
var surfing: bool = false
var running: bool = false

var last_input_direction = null
var move_from_event = false
var eventOn = false
var blocked = false

var transparent = false

var colliding = false

func _ready():
	$Sprite.visible = true
	anim_tree.active = true
	initial_position = position
	anim_tree.set("parameters/Idle/blend_position", input_direction)
	anim_tree.set("parameters/Walk/blend_position", input_direction)
	anim_tree.set("parameters/Turn/blend_position", input_direction)
	anim_tree.set("parameters/Run/blend_position", input_direction)

func process_player_movement_input():
	
	if input_direction.y == 0 and !move_from_event and !eventOn and !blocked and !GUI.isVisible():
		input_direction.x = int(INPUT.is_action_player_pressed("ui_right")) - int(INPUT.is_action_player_pressed("ui_left"))
	if input_direction.x == 0 and !move_from_event and !eventOn and !blocked and !GUI.isVisible():
		input_direction.y = int(INPUT.is_action_player_pressed("ui_down")) - int(INPUT.is_action_player_pressed("ui_up"))
	if input_direction != Vector2.ZERO:
		
		anim_tree.set("parameters/Idle/blend_position", input_direction)
		anim_tree.set("parameters/Walk/blend_position", input_direction)
		anim_tree.set("parameters/Turn/blend_position", input_direction)
		anim_tree.set("parameters/Run/blend_position", input_direction)
		
		#Comprovem si es pot fer el moviment, i/o com serà el moviment
		checkMoveStatus()
		print(MoveState.keys()[move_state])
		
		if move_state == MoveState.TURN:
			move_state = MoveState.TURNING
			anim_state.travel("Turn")
			#print("turned")
			#player_turned_signal.emit()
			emit_signal("turned_signal")
			remote_turned_signal.emit(1)
			#emit_signal("player_turned_signal")
		else:
			initial_position = position
			is_moving = true

	else:
		anim_state.travel("Idle")
		move_state = MoveState.IDLE
		if !input_pressed():
			continued = false
		

func need_to_turn(update_facing = true):
	var new_facing_direction
	var new_op_facing_direction
	#print("CHEKEANDO ", continued)
	if input_direction.x < 0:
		#print("update left")
		new_facing_direction = FacingDirection.LEFT
		new_op_facing_direction = OppositeFacingDirection.RIGHT
	elif input_direction.x > 0:
		#print("update right")
		new_facing_direction = FacingDirection.RIGHT
		new_op_facing_direction = OppositeFacingDirection.LEFT
	elif input_direction.y < 0:
		#print("update up")
		new_facing_direction = FacingDirection.UP
		new_op_facing_direction = OppositeFacingDirection.DOWN
	elif input_direction.y > 0:
		#print("update down")
		#print("old face ", facing_direction)
		new_facing_direction = FacingDirection.DOWN
		new_op_facing_direction = OppositeFacingDirection.UP
	
	if facing_direction != new_facing_direction:
		if update_facing:
			facing_direction = new_facing_direction
			opposite_facing_direction = new_op_facing_direction
		return true
	if update_facing:
		facing_direction = new_facing_direction
		opposite_facing_direction = new_op_facing_direction
	return false
		
func finished_turning():
	move_state = MoveState.IDLE
	
func finished_moving():
	pass
	continued = input_pressed()
	
func move(delta):
	if move_state == MoveState.JUMP or move_state == MoveState.JUMPING: #jumping:
		doJump(delta)
	elif move_state == MoveState.WALK or move_state == MoveState.WALKING: #!colliding && !jumping:	
		doStep(delta)
	elif move_state == MoveState.COLLIDE:#else:
		is_moving = false
		move_state == MoveState.IDLE
		remote_collided_signal.emit(2)
		SignalManager.PLAYER.collided.emit()
		
#Funció que detecta i retorna el tile que hi ha davant del jugador
func get_tile(tilemap:TileMap, layer: int, pos: Vector2):
	var tile_coords = tilemap.local_to_map(pos  - GLOBAL.actual_map.global_position) # position + desired_step
	var data = null
		#Es el tile set, en aquest cas Outdoor (id 0)
	var source_id = tilemap.get_cell_source_id(layer, tile_coords, false)
	var atlas_coords = tilemap.get_cell_atlas_coords(layer, tile_coords, false)
	
	if source_id != -1:
		if tilemap.tile_set.get_source(source_id) is TileSetAtlasSource:
			var source: TileSetAtlasSource = tilemap.tile_set.get_source(source_id)
			
			if source != null:
				var tile_data := source.get_tile_data(atlas_coords, 0)
				data = tile_data
				#return tile_data
		else:
			var source: TileSetScenesCollectionSource = tilemap.tile_set.get_source(source_id)
			var tile_id = source.get_alternative_tile_id(atlas_coords, 0)
			data = source.get_scene_tile_scene(tile_id).instantiate()
			#var source: TileSetScenesCollectionSource = tilemap.tile_set.get_source(source_id)
			#var tile_id = source.get_next_scene_tile_id()-1
			#return source.get_scene_tile_scene(tile_id)
	
		
		#pass #de moment ho comento, no recordo que es aixo de scenes collection
#		var source: TileSetScenesCollectionSource = tilemap.tile_set.get_source(source_id)
#		if source != null:
#			var tile_id = source.get_alternative_tile_id(atlas_coords, 0)
#			return source.get_scene_tile_scene(tile_id).instantiate()
		
	return data
	
# Funció que es crida desde l'AnimationPlayer a l'inici de l'animació de Walk i Turn per detectar el següent tile
func get_next_tile(_pos = position + (input_direction * TILE_SIZE)):
	var pos = _pos
	var tilemap = GLOBAL.actual_map.active_tilemap
	var layer = 0
	var data = null
	var tile_coords = tilemap.local_to_map(pos - GLOBAL.actual_map.global_position) # position + desired_step
	var atlas_coords = tilemap.get_cell_atlas_coords(layer, tile_coords, false)
		#Es el tile set, en aquest cas Outdoor (id 0)
	var source_id = tilemap.get_cell_source_id(layer, tile_coords, false)

	if source_id != -1:
		if tilemap.tile_set.get_source(source_id) is TileSetAtlasSource:
			var source: TileSetAtlasSource = tilemap.tile_set.get_source(source_id)
			
			if source != null:
				var tile_data := source.get_tile_data(atlas_coords, 0)
				data = tile_data
		else:
			var source: TileSetScenesCollectionSource = tilemap.tile_set.get_source(source_id)
			var tile_id = source.get_alternative_tile_id(atlas_coords, 0)
			data = source.get_scene_tile_scene(tile_id).instantiate()
		#	print("tile name ", data.get_name())
	if data == null:	
		next_tile = null
	else:
#		print("next tile", data)
		#print("Tipus ", data.get_custom_data("Tipus"))
		next_tile = data
			
func is_colliding(dir : int = -1):
	if dir != -1:
		changeRayCastDirection(dir)
		rayTiles.force_raycast_update()
#	var rayCollide = rayTiles.is_colliding()
#	resetRayCastDirection()
	
	var nextTileIsEmpty = nextTileIsEmpty(facing_direction, 0b0001 | 0b0100 | 100000)  #Els colision/layer masks s'informen en bits (bitmask),Ex; Capa 6 = valor 32 = 100000
	
	if next_tile != null:
		return !nextTileIsEmpty or rayTiles.is_colliding() or next_tile.get_custom_data("Tipus") == CONST.TILE_TYPE.SURF or !can_enter_tile() or !can_exit_tile()
	return !nextTileIsEmpty or rayTiles.is_colliding() or !can_exit_tile()

#Calcula si el següent tile té colisió i també obté la custom data del tile
func update_map_data():
	#Només ho comprovem al inici del moviment, perque no faci un update cada frame
#	if percent_moved_to_next_tile == 0.0:
		var desired_step: Vector2 = input_direction * TILE_SIZE / 2
		if GLOBAL.actual_map != null:
			pass
#			if next_tile != null:	
#				var data = next_tile.get_custom_data("Tipus")
		else:
			print("GLOBAL.actual_map is null")
		rayTiles.target_position = desired_step
		rayTiles.force_raycast_update()
		actual_tile = get_tile(GLOBAL.actual_map.active_tilemap, 0, position)
		get_next_tile()
		

#Si el següent tile té oberta la direcció oposada a on jo estic anant, vol dir que puc entrar. Exemple:
# Jo vaig cap amunt (UP) per tant necessito que el següent tile tingui obert el DOWN
func can_enter_tile():
#	var uwu1 = next_tile.get_custom_data("EnterDirections")#next_tile == null
#	var uwu2 = next_tile.get_custom_data("EnterDirections") == []
#	var uwu3 = next_tile.get_custom_data("EnterDirections").has(CONST.OPPOSITE_DIRECTIONS.keys()[facing_direction])
#	var uwu4 = CONST.OPPOSITE_DIRECTIONS.keys()[facing_direction]
#	var uwu5 = next_tile.get_custom_data("EnterDirections")
	
	return next_tile == null or next_tile.get_custom_data("EnterDirections") == []  or next_tile.get_custom_data("EnterDirections").has(CONST.OPPOSITE_DIRECTIONS.keys()[facing_direction])

#Si el tile actual on es troba el jugador té oberta la direcció cap on jo m'estic movent, vol dir que puc sortir.Exemple:
# Jo vaig cap amunt (UP) per tant necessito que el tile actual  tingui obert el UP
func can_exit_tile():
	return actual_tile == null or actual_tile.get_custom_data("ExitDirections") == [] or actual_tile.get_custom_data("ExitDirections").has(CONST.DIRECTIONS.keys()[facing_direction])

#Talla per un moment el moviment del jugador perque deixi de detectarlo com a moviment continuat (com si aixequessis el dit del botó)
func stop_movement():
	input_direction.x = 0
	input_direction.y= 0
	continued = false

#El jugador queda bloquejat sense moure's fins que es desbloqueja amb l'unblock_movement()
func block_movement():
	input_direction = Vector2.ZERO
	blocked = true

#Desbloqueja el moviment del jugador previament bloquejat amb l'unblock_movement()
func unblock_movement():
	input_direction = Vector2.ZERO
	blocked = false

func input_pressed():
	return Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down")

	
func set_transparent(state):
	transparent = state
	get_node("Sprite").visible = !state
	
func sprite_to_idle():
	if facing_direction == FacingDirection.DOWN:
		sprite.frame = 0
	elif facing_direction == FacingDirection.LEFT:
		sprite.frame = 4
	elif facing_direction == FacingDirection.RIGHT:
		sprite.frame = 8
	if facing_direction == FacingDirection.UP:
		sprite.frame = 12

func changeRayCastDirection(dir : CONST.InputDirections):
	if dir == CONST.InputDirections.UP:
		$RayCastTiles.target_position = Vector2(0, -32)
	elif dir == CONST.InputDirections.DOWN:
		$RayCastTiles.target_position = Vector2(0, 32)
	elif dir == CONST.InputDirections.RIGHT:
		$RayCastTiles.target_position = Vector2(32, 0)
	elif dir == CONST.InputDirections.LEFT:
		$RayCastTiles.target_position = Vector2(-32, 0)

func resetRayCastDirection():
	$RayCastTiles.target_position = Vector2(0, 32)
	

func checkNextStepArea(dir : CONST.InputDirections):
	var position_target : Vector2
	var areaName = ""
	
	if dir == CONST.InputDirections.UP:
		print(name + " attemps up move ")
		position_target = position + Vector2(0, -32)
	elif dir == CONST.InputDirections.DOWN:
		print(name + " attemps down move ")
		position_target = position + Vector2(0, 32)
	elif dir == CONST.InputDirections.RIGHT:
		print(name + " attemps right move ")
		position_target = position + Vector2(32, 0)
	elif dir == CONST.InputDirections.LEFT:
		print(name + " attemps left move ")
		position_target = position + Vector2(-32, 0)
	
	#Li sumem Vector2(16,16) perque ens detecti el punt en el centre del requadre, i no en la cantonada
	position_target += Vector2(16,16)
#	print(name + " position " + str(position))
#	print("position target " + str(position_target))
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = position_target
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = 16

	var space_state = get_world_2d().direct_space_state
	var result : Array[Dictionary] = space_state.intersect_point(parameters)

#	var shape: RectangleShape2D = RectangleShape2D.new()
#	shape.size = Vector2(16,16)
#
#	var parameters = PhysicsShapeQueryParameters2D.new()
#	parameters.transform = Transform2D(0.0, position_target)
#	parameters.shape = shape
#	parameters.collide_with_areas = true
#	parameters.collide_with_bodies = false
#	parameters.collision_mask = 16
#
#	var space_state = get_world_2d().direct_space_state
#	var result : Array[Dictionary] = space_state.intersect_shape(parameters)

	if result.size() != 0:
		print(result[0]["collider"].name)
		areaName = result[0]["collider"].name
		
	return areaName
	
#Funció que comprova si el següent tile no està ocupat per cap altre evento. També evita que dos eventos entrin al mateix
#tile a la vegada
func nextTileIsEmpty(dir : CONST.InputDirections, collMask = null):
	var position_target: Vector2 = Vector2(0, 0)
	
	#Li sumem Vector2(16,16) perque ens detecti el punt en el centre del requadre, i no en la cantonada
	if dir == CONST.InputDirections.UP:
		position_target = position + Vector2(0, -32) + Vector2(16,16)
	elif dir == CONST.InputDirections.DOWN:
		position_target = position + Vector2(0, 32) + Vector2(16,16)
	elif dir == CONST.InputDirections.RIGHT:
		position_target = position + Vector2(32, 0) + Vector2(16,16)
	elif dir == CONST.InputDirections.LEFT:
		position_target = position + Vector2(-32, 0) + Vector2(16,16)
		
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(31.5,31.5)
	
	var parameters = PhysicsShapeQueryParameters2D.new()
	parameters.transform = Transform2D(0.0, position_target)
	parameters.shape = shape
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = true
	parameters.exclude = []#[GLOBAL.actual_map.active_tilemap.get_canvas()]
	parameters.collision_mask = collMask
#	if self.is_in_group("Event"):
#		parameters.laye = collMask
	
	var space_state = get_world_2d().direct_space_state
	var result : Array[Dictionary] = space_state.intersect_shape(parameters)

	if result.size() != 0:
		print("next tile: " + result[0]["collider"].name)
	return result == []

#Funció que s'executa just abans de es faci un moviment (step)
func beforeStep():
	if percent_moved_to_next_tile == 0.0:
		update_map_data()
		

#Funció que realitza el moviment del Player/Evento fins moure's completement en el següent tile
func doStep(delta):
	if percent_moved_to_next_tile == 0.0: #Ha de comencar el moviment
		emit_signal("moving_signal")
	percent_moved_to_next_tile += walk_speed * delta
	if percent_moved_to_next_tile >= 0.95: #Ja ha realitzat tot el moviment (tile seguent)
		position = initial_position + (input_direction * TILE_SIZE)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		emit_signal("moved_signal")
		remote_moved_signal.emit(0)
		if input_pressed():
			continued = true
			move_state == MoveState.WALKING
		else:
			move_state == MoveState.IDLE
	else: #Està realitzant el moviment
		#print(MoveState.keys()[move_state])
		move_state == MoveState.WALKING
		position = initial_position + (input_direction * TILE_SIZE * percent_moved_to_next_tile)

#Funció que realitza el moviment de saltar un ledge.
func doJump(delta):
	percent_moved_to_next_tile += jump_speed * delta
	if percent_moved_to_next_tile >= 2.0:
		position = initial_position + (input_direction * TILE_SIZE * 2)
		percent_moved_to_next_tile = 0.0
		is_moving = false
		#jumping = false
		move_state = MoveState.WALK
		block_movement()
		var dust_effect = LandingDustEffect.instantiate()
		dust_effect.target = self
		dust_effect.position = position
		get_tree().current_scene.add_child(dust_effect)
	else:
		jumping = true
		move_state = MoveState.JUMPING
		if facing_direction == FacingDirection.LEFT or facing_direction == FacingDirection.RIGHT:
			var input = (input_direction.x) * TILE_SIZE * percent_moved_to_next_tile
			position.x = initial_position.x + (-0.96 - 0.53 * input + 0.025 * pow(input, 2))
		elif facing_direction == FacingDirection.UP or facing_direction == FacingDirection.DOWN:
			var input = (input_direction.y) * TILE_SIZE * percent_moved_to_next_tile
			position.y = initial_position.y + (-0.96 - 0.53 * input + 0.025 * pow(input, 2))
	
func afterStep():
	pass

#Funció que comprova si es pot fer el moviment, i quin tipus de moviment (jump, caminar etc)
func checkMoveStatus():
	
	update_map_data()
	
	if need_to_turn() and !continued:
		move_state = MoveState.TURN
	elif is_colliding():
		move_state = MoveState.COLLIDE
	elif ((next_tile != null and next_tile.get_custom_data("Tipus") == CONST.TILE_TYPE.LEDGE) and can_enter_tile()):
		move_state = MoveState.JUMP
	else:
		move_state = MoveState.WALK
	
	#colliding = is_colliding()

