extends Node

signal cmd_started
signal cmd_finished

#@export var Scene: PackedScene
@export var Scene: String
@export var Player_position: Vector2
var fade = preload("res://Objetos/Event/Event Commands/cmd_FadeToNormal.tscn")

func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SignalManager.CMD.started.emit()
	print(str(name) + " started")
	if Scene != null and Player_position != null:
		var s = load("res://Escenas/Mapas/" + Scene + ".tscn")
		GLOBAL.SCENE_MANAGER.transition_to_scene(s, Player_position, true)
		
#		fade.instantiate().exec()
#		await GLOBAL.SCENE_MANAGER.animationPlayer.animation_finished
		#await GLOBAL.SCENE_MANAGER.transitioned
		
	print(str(name) + " finished")
	SignalManager.CMD.finished.emit()
