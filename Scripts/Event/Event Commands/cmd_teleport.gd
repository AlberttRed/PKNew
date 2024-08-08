extends Node

signal cmd_started
signal cmd_finished

@export var Evento: NodePath
@export var Map_XY: Vector2


func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SignalManager.CMD.started.emit()
	print(str(name) + " started")
	if Evento != null and Map_XY != null:
		get_node(Evento).set_position(Map_XY)
	print(str(name) + " finished")
	SignalManager.CMD.finished.emit()
