extends Node

@onready var EVENT = event.new()
@onready var EVENT_PAGE = event_page.new()
@onready var CMD = commands.new()
@onready var SCENE_MANAGER = scene_manager.new()
@onready var PLAYER = player.new()

class event:
	pass
#	signal started
#	signal finished
	signal play_animation
	signal animation_started
	signal animation_finished
	signal check_pending_moves
	signal moves_finished
	signal add_cmd_move
	signal delete_cmd_move
	signal moved

class event_page:
#	signal started
#	signal finished
	signal load_sprite
	signal set_through
	
class commands:
	signal started
	signal finished
	signal selected_choice
	signal waited
	
class scene_manager:
	signal events_finished
	signal finished_transition
	signal load_map_connections
	
class player:
	signal collided
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	EVENT = event.new()


