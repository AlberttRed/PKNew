extends Node2D

class_name Map

@onready var active_tilemap :TileMap = $TileMap
@onready var encounterAreas = $WildEncounters
@onready var NPCmovementArea : Area2D = $NPCMovementArea
#comentat el pakcedScene perque peta al carregar, suposo que es un bug de Godot
#de moment farem servir array d'strings amb el nom del mapa
#@export var map_connections: Array[PackedScene]
@export var map_connections: Array[String]

@export var map_connections_pos: Array[Vector2i]

var map_connections_list: Array[Node2D] = []
var on_load_fadetoNormal = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("Entered map ", self.get_name())
		
		if GLOBAL.actual_map != self:
			GLOBAL.previous_map = GLOBAL.actual_map
			GLOBAL.actual_map = self
			#GLOBAL.SCENE_MANAGER.load_player(self)
			
		
		#SIGNALS.SCENE_MANAGER.load_map_connections.emit(self)
		#GLOBAL.SCENE_MANAGER.load_map_connections(self)
		GLOBAL.SCENE_MANAGER.call_deferred("load_map_connections", self)
		if GLOBAL.previous_map != null:
			GLOBAL.SCENE_MANAGER.delete_map_connections(GLOBAL.previous_map)
			#GLOBAL.SCENE_MANAGER.call_deferred("delete_map_connections", GLOBAL.previous_map)
		
func get_encounterArea(area_id: int):
	for a in encounterAreas.get_children():
		if a.encounterArea.type == area_id:
			return a
	push_error("The encounter area " + CONST.ENCOUNTER_METHODS.keys()[area_id] + " is not setted for map " + str(GLOBAL.actual_map.name))
	return null


