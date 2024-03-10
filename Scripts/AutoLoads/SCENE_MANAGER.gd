extends Node2D

signal transitioned

@onready var animationPlayer = $AnimationPlayer
@onready var events = $Eventos

@export var play_intro: bool = false
@export var current_scene: PackedScene = null
@export var initial_position: Vector2 = Vector2(0, 0)

var player_position: Vector2 = Vector2(0, 0)

var next_scene

var Player = preload("res://Objetos/Player.tscn").instantiate()
var active_events = []

var loaded_maps: Array[String] = []

var faded = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#SIGNALS.SCENE_MANAGER.connect("load_map_connections", Callable(self, "load_map_connections"))
	
	print("loading map from " + str(name))
	GLOBAL.SCENE_MANAGER = self
	GLOBAL.PLAYER = Player
	GLOBAL.actual_map = current_scene.instantiate()
	
	load_map(GLOBAL.actual_map)
	load_player(GLOBAL.actual_map, initial_position)
	

func transition_to_scene(new_scene, player_pos: Vector2, fade_to_normal: bool):
	next_scene = new_scene
	player_position = player_pos
	

	#$CurrentScene.get_child(0).queue_free()
	print(str(GLOBAL.actual_map.name))
	delete_map_connections(GLOBAL.actual_map)
	loaded_maps.erase(str(GLOBAL.actual_map.name))
	$LoadedScenes.get_node(str(GLOBAL.actual_map.name)).queue_free()
	get_tree().call_group(str(GLOBAL.actual_map.name), "set_delete_at_finish", true)
	get_tree().call_group(str(GLOBAL.actual_map.name), "disable", true)
	GLOBAL.actual_map = next_scene.instantiate()
	GLOBAL.actual_map.on_load_fadetoNormal = fade_to_normal
	load_map(GLOBAL.actual_map)
	load_player(GLOBAL.actual_map, player_position)
	#GLOBAL.PLAYER.set_transparent(GLOBAL.PLAYER.transparent)
#	animationPlayer.play("FadeToNormal")
#	await animationPlayer.animation_finished
	print("ñeñeñe")
	#transitioned.emit()
	#SIGNALS.SCENE_MANAGER.finished_transition.emit()
	
func load_map(map, map_pos = Vector2(0, 0), connection:bool = false):
	#map.set_owner = self
	
	if !loaded_maps.has(str(map.name)):
		print("loading map ", str(map.name))
		if connection:
			$LoadedScenes.add_child(map)
			map.position = GLOBAL.actual_map.position + Vector2(map_pos.x, map_pos.y)
			GLOBAL.actual_map.map_connections_list.push_back(map)
		else:
			$LoadedScenes.add_child(map)
			map.position = map_pos
		
		#load_map_connections(map)
		loaded_maps.push_back(str(map.name))
		if map.on_load_fadetoNormal:
			animationPlayer.play("FadeToNormal")
			await animationPlayer.animation_finished
			GLOBAL.PLAYER.unblock_movement()
		print("map loaded")
		
	else:
		if connection:
			GLOBAL.actual_map.map_connections_list.push_back($LoadedScenes.get_node(str(map.name))) 
		#else:
		map.queue_free()
		print(str(map.name) + " already loaded")
	
func load_player(_map, player_pos = Vector2(0, 0)):
	#print("adding player to map ", map.name)

#	if GLOBAL.PLAYER.get_parent() != null:
#		GLOBAL.PLAYER.get_parent().remove_child(GLOBAL.PLAYER)
#	map.add_child(GLOBAL.PLAYER)
	if !$LoadedScenes.has_node("Player"):
		$LoadedScenes.add_child(GLOBAL.PLAYER)
	
	print("player ", GLOBAL.PLAYER)
	
	if player_pos != Vector2(0, 0):
		GLOBAL.PLAYER.position = player_pos

	
	print("player loaded")
	

func load_map_connections(currentScene):
	var connection_scene: Node2D	
	var i:int = 0
	
	for map in currentScene.map_connections:
		if currentScene.map_connections_pos[i] != null:
			connection_scene = GLOBAL.Maps[map].instantiate()
			load_map(connection_scene, currentScene.map_connections_pos[i], true)
			#currentScene.map_connections_list.push_back(connection_scene)
			print(str(connection_scene.name) + " connected to " + str(currentScene.name))
		i += 1
			

func delete_map_connections(map:Node2D):
	print("list to delete: " + str(map.map_connections_list))
	for con in map.map_connections_list:
		if con.name != GLOBAL.actual_map.name:
			print("connection " + str(con.name) + " disconnected from " + str(map.name))
			map.map_connections_list.erase(con)
			$LoadedScenes.remove_child($LoadedScenes.get_node(str(con.name)))
			con.queue_free()
			loaded_maps.erase(str(con.name))
		

#func set_current_Scene(map:Node2D):
#	if map.get_parent() != null:
#		map.get_parent().remove_child(map)
#	$LoadedScenes/CurrentScene.add_child(map)
#
#func set_connection_Scene(map:Node2D):
#	if map.get_parent() != null:
#		map.get_parent().remove_child(map)
#	$LoadedScenes/ConnnectionSecenes.add_child(map)


func wait_events_to_completion():
	print("active events", active_events)
	while !active_events.is_empty():
		await get_tree().process_frame
	
	SIGNALS.SCENE_MANAGER.events_finished.emit()
	
func add_active_event(event):
	print("added event " + str(event.name) + " to " + str(name))
	active_events.push_back(event)
	
	
func delete_active_event(event):
	#print("deleted event " + str(event.name) + " on " + str(name))
	active_events.erase(event)
	if !event.delete_at_finish:
		event.get_parent().remove_child(event)
		event.executing = false
		event.original_parent.add_child(event)
		#print(str(event.name) + " set through " + str(event.get_collision_layer_value(1)))
	#event.shape.disabled = false
	
func exec_event(event):
	#event.shape.disabled = true
	
	active_events.push_back(event)
	event.get_parent().remove_child(event)
	events.add_child(event)
	event.executing = true
	event.exec()
	#events.get_node(str(event.name)).exec()
