extends Node

signal cmd_started
signal cmd_finished

@export var nodePath:NodePath
@export var Through:bool = false
var Target



func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))
	
func exec():
	SIGNALS.CMD.started.emit()
	print(str(name) + " started")
	print("hola")
	if nodePath.is_empty():
		Target = GLOBAL.PLAYER
	else:
		Target = get_node(nodePath)
	print("hola")
	Target.set_through(Through)
	print("adeu")
	print(str(name) + " finished")
	SIGNALS.CMD.finished.emit()
#
#func wait(s):
#	var timer = Timer.new()
#	timer.set_wait_time(s)
#	timer.start()
#	yield(timer,"timeout")
#	parentPage.finished_command()
#	emit_signal("finished")
