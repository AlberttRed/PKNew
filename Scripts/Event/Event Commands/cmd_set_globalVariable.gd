extends Node

@export var variable:String
@export var state:bool = false

func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SignalManager.CMD.started.emit()
	print(str(name) + " started")
	
	if !variable.is_empty():
		EVENTS_CONDITIONS.get_node(variable).state = state
		print("Set " + str(EVENTS_CONDITIONS.get_node(variable).name) + " " + str(state))
		
	print(str(name) + " finished")
	SignalManager.CMD.finished.emit()
#
#func wait(s):
#	var timer = Timer.new()
#	timer.set_wait_time(s)
#	timer.start()
#	yield(timer,"timeout")
#	parentPage.finished_command()
#	emit_signal("finished")
