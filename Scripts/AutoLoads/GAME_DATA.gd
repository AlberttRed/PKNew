extends Node

var player_surf_sprite = preload("res://Sprites/Overworlds/Characters/boy_surf_offset.png")
var player_run_sprite = preload("res://Sprites/Overworlds/Characters/boy_run.png")
var player_default_sprite = preload("res://Sprites/Overworlds/Characters/trchar000.png")

var player_name : String = "RED"
var trainer: Battler
var medals : Array[int] = []
var player_id : int = 1234#randi() % 999999 + 1
var actual_position : Vector2
var ITEMS : Array[int] = []

var party : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
