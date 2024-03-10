extends "res://Scripts/CharacterController.gd"

signal started
signal finished

@onready var animationPlayer = $AnimationPlayer
@onready var event_pages = $Pages.get_children()
@onready var area = $Area2D2
@onready var shape = $Area2D2/CollisionShape2D

@onready var original_parent = get_parent()

var area_entered = false
var executing = false

var remoteMovement : RemoteMovement

#@onready var sprite = $Sprite
@export_enum("NPC", "Event") var event_type: int
@export var walk: bool = false
@onready var active_page = null
var delete_at_finish = false

var cmd_moves_active = []

var Through: bool:
	get: return active_page.Through
var Interact: bool = false:
	get: return active_page.Interact
var DirectionFix: bool = false:
	get: return active_page.DirectionFix
var PlayerTouch: bool = false:
	get: return active_page.PlayerTouch
var EventTouch: bool = false:
	get: return active_page.EventTouch
var AutoRun: bool = false:
	get: return active_page.AutoRun
var Paralelo: bool = false:
	get: return active_page.Paralelo

func _ready():
	$Sprite.texture = null
	move_from_event = true
	set_physics_process(false)
	set_process(false)
	anim_tree = $AnimationTree
	anim_tree.active = true
	anim_state = anim_tree.get("parameters/playback")
	rayTiles = $RayCastTiles	
	anim_tree.set("parameters/Idle/blend_position", input_direction)
	anim_tree.set("parameters/Walk/blend_position", input_direction)
	anim_tree.set("parameters/Turn/blend_position", input_direction)
	add_to_group(str(GLOBAL.actual_map.name))
	
	get_active_page()
	if event_type == 0:
		#add_area2D()
		$Sprite.offset.y = -16
		
	if walk and event_type == CONST.EVENT.TYPE.NPC:
		set_process(true)
		remoteMovement = RemoteMovement.new(self)#load("res://Scripts/RemoteMovement.gd").new()
		add_child(remoteMovement)
		setWalkTimer()

	#setWalkTimer()
		
func _exit_tree():
	GLOBAL.disconnect_signal(area, "body_entered", Callable(self, "_on_area_body_entered"))
	GLOBAL.disconnect_signal(area, "body_exited", Callable(self, "_on_area_body_exited"))

func _enter_tree():
	if area != null && !executing:
		area.connect("body_entered", Callable(self, "_on_area_body_entered"))
		area.connect("body_exited", Callable(self, "_on_area_body_exited"))

func _process(delta):
			
	var areas = area.get_overlapping_areas()
		
	if !area.overlaps_area(GLOBAL.actual_map.NPCmovementArea):
		push_error("NPC " + str(name) + " is not in an NPC area!")
	set_process(false)

func exec():
	#SIGNALS.EVENT.started.emit()
	started.emit()
	#GLOBAL.SCENE_MANAGER.add_active_event(self)
	print("event started")
	SIGNALS.EVENT.connect("play_animation", Callable(self, "play_animation"))
	SIGNALS.EVENT.connect("check_pending_moves", Callable(self, "check_pending_moves"))
	SIGNALS.EVENT.connect("add_cmd_move", Callable(self, "add_cmd_move"))
	SIGNALS.EVENT.connect("delete_cmd_move", Callable(self, "delete_cmd_move"))
	
	if !Paralelo:
		GLOBAL.PLAYER.eventOn = true
	
	active_page.call_deferred("exec")
	await active_page.finished
	#await SIGNALS.EVENT_PAGE.finished
	await check_pending_moves()
	
	print("event finished")
	SIGNALS.EVENT.disconnect("check_pending_moves", Callable(self, "check_pending_moves"))
	SIGNALS.EVENT.disconnect("add_cmd_move", Callable(self, "add_cmd_move"))
	SIGNALS.EVENT.disconnect("delete_cmd_move", Callable(self, "delete_cmd_move"))
	SIGNALS.EVENT.disconnect("play_animation", Callable(self, "play_animation"))
	GLOBAL.SCENE_MANAGER.delete_active_event(self)
	
	finished.emit()
	get_active_page()
	#SIGNALS.EVENT.finished.emit()
	
	if !Paralelo:
		GLOBAL.PLAYER.eventOn = false
	
	if delete_at_finish:
		queue_free()
	

func get_active_page():
	
	active_page = event_pages.front()
	
	GLOBAL.disconnect_signal(SIGNALS.EVENT_PAGE, "load_sprite", Callable(self, "load_sprite"))
	GLOBAL.disconnect_signal(SIGNALS.EVENT_PAGE, "set_through", Callable(self, "set_through"))
	for p in event_pages:
			if !p.condition1.is_empty():
				print("CONDITION: " + p.condition1 + ": " + str(EVENTS_CONDITIONS.get_node(p.condition1).get_state()))
				if EVENTS_CONDITIONS.get_node(p.condition1).get_state():
					print(EVENTS_CONDITIONS.get_node(p.condition1).get_state())
					active_page = p
			elif !p.condition2.is_empty():
				if EVENTS_CONDITIONS.get_node(p.condition2).get_state():
					active_page = p
			elif !p.condition3.is_empty():
				if EVENTS_CONDITIONS.get_node(p.condition3).get_state():
					active_page = p
	#active_page.parentEvent = self
#	active_page.connect("load_sprite", Callable(self, "load_sprite"))
#	active_page.connect("set_through", Callable(self, "set_through"))
#	active_page.init_page()
	print("page selected: " + str(active_page.name))
	SIGNALS.EVENT_PAGE.connect("load_sprite", Callable(self, "load_sprite"))
	SIGNALS.EVENT_PAGE.connect("set_through", Callable(self, "set_through"))
	active_page.init_page()
	GLOBAL.disconnect_signal(SIGNALS.EVENT_PAGE, "load_sprite", Callable(self, "load_sprite"))
	GLOBAL.disconnect_signal(SIGNALS.EVENT_PAGE, "set_through", Callable(self, "set_through"))
	
func add_area2D():
	var rectangleshape = RectangleShape2D.new()
	rectangleshape.size = Vector2(32, 32)
	var colissionshape = CollisionShape2D.new()
	colissionshape.position = Vector2(16, 16)
	colissionshape.shape = rectangleshape
	self.add_child(colissionshape)
	
func load_sprite(_sprite, sprite_cols, sprite_rows, offsetSprite):
	print(self.name)
	print(sprite_cols)
	if _sprite != null:
		$Sprite.texture = _sprite
		$Sprite.hframes = sprite_cols
		$Sprite.vframes = sprite_rows
		$Sprite.offset = offsetSprite
		if _sprite.get_height() / 32 > 1 and (sprite_cols == 1 and sprite_rows == 1):
			$Sprite.offset = $Sprite.offset + (Vector2(0,-16*(_sprite.get_height() / 32 - 1)))
			

	#$Area2D2/CollisionShape2D.disabled = state



func _on_area_body_entered(body):
	if PlayerTouch && body.is_in_group("Player"):
		print("area_entered ", area_entered)
	if !area_entered:
		#print("throug ", Through)
		if (PlayerTouch && body.is_in_group("Player") and Through) or (EventTouch && body.is_in_group("Event") and Through):
			
			area_entered = true
			print("castaña")
			print(str(body.name) + " entered on " + str(self.name))
			if body.is_moving:
				await body.moved_signal
			body.stop_movement()
	#		#$Area2D2/CollisionShape2D.disabled = true
			GLOBAL.SCENE_MANAGER.call_deferred("exec_event", self)#exec_event(self)

func play_animation(animation):
	anim_tree.active = false
	print("hframes ", $Sprite.hframes)
	print("vframes ", $Sprite.vframes)
	#animationPlayer.libraries["Eventos"].add_animation(animation.get_name(), animation)
	animationPlayer.play("Eventos/" + animation.get_name())
	await animationPlayer.animation_finished
	#animationPlayer.remove_animation("Eventos/" + animation.get_name())
	SIGNALS.EVENT.animation_finished.emit()
	
func check_pending_moves():
	print("moves active ", cmd_moves_active)
	while !cmd_moves_active.is_empty():
		await get_tree().process_frame
	
	SIGNALS.EVENT.moves_finished.emit()
	
func add_cmd_move(cmd):
	print("added move " + str(cmd.name) + " to " + str(name))
	cmd_moves_active.push_back(cmd)
	#print("moves active ", cmd_moves_active)
	
func delete_cmd_move(cmd):
	print("deleted move " + str(cmd.name) + " on " + str(name))
	cmd_moves_active.erase(cmd)
	#print("moves active ", cmd_moves_active)

func set_delete_at_finish(state):
	if self.is_in_group("Event"):
		delete_at_finish = state
		
func disable(d):
	if self.is_in_group("Event"):
		if d:
			hide()
			set_through(d)
			$Area2D2.monitoring = !d
			$Area2D2.monitorable = !d
			$Area2D2/CollisionShape2D.disabled = d
#
#func set_delete_at_finish_false():
#	if self.is_in_group("Event"):
#		delete_at_finish = false
#


func _on_area_body_exited(body):
	if (PlayerTouch && body.is_in_group("Player")) or (EventTouch && body.is_in_group("Event")):
		print(str(body.name) + " exited from " + str(self.name))
		await body.moved_signal
		area_entered = false
		
func setWalkTimer(state : bool = true):
	var seconds: Array[int] = [3,5,7]
	randomize()
	if state:
		$WalkTimer.start(seconds[randi_range(0,2)])
	else:
		$WalkTimer.stop()


func _on_walk_timer_timeout():
	await remote_move([randi_range(0, 7)], true) # li passo del 0 al 7 perque son els primers 8 moves del CONST.MOVE_COMMANDS: LEFT, RIGHT, UP, DOWN, TURN_LEFT, TURN_RIGHT, TURN_UP, TURN_DOWN
	setWalkTimer()
	
	
#Se li informe la llista de moviments a realitzar, i si es tracta d'un moviment aleatori o no	
func remote_move(movements : Array[RemoteMovement.Directions], randomMovement : bool = false):
	#print(str(name) + ", current direction: " + str(facing_direction) + ", new dir: " + str(movements))

	remoteMovement.move(movements, randomMovement)
	#print("a")
	await remoteMovement.movement_finished
	#print("o")

func isInArea():
	pass
	
func is_NPCArea(dir : int = -1):
	if dir != -1:
		changeRayCastDirection(dir)
		rayTiles.force_raycast_update()
#	var rayCollide = rayTiles.is_colliding()
#	resetRayCastDirection()
	
	if next_tile != null:
		return rayTiles.is_colliding() or next_tile.get_custom_data("Tipus") == CONST.TILE_TYPE.SURF or !can_enter_tile() or !can_exit_tile()
	return rayTiles.is_colliding() or !can_exit_tile()

func set_through(state):

	#Capa Player
#	set_collision_mask_value(1, !state)
#	area.set_collision_mask_value(1, !state)
	#Capa Eventos
	set_collision_layer_value(3, !state)
	area.set_collision_layer_value(3, !state)
	
	set_collision_layer_value(6, !state)
	area.set_collision_layer_value(6, !state)
#	set_collision_mask_value(3, !state)
#	area.set_collision_mask_value(3, !state)

	#Capa NPCMovement
#	set_collision_mask_value(5, !state)
#	area.set_collision_mask_value(5, !state)
