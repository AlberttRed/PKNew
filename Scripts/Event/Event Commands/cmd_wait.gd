extends Node

#signal cmd_started
#signal cmd_finished

@export var time:float
@onready var t = $Timer

func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SignalManager.CMD.started.emit()
	print(t)
	print(str(name) + " started")
	print(t)
	t.set_wait_time(time)
	t.start()
	await t.timeout
	
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
