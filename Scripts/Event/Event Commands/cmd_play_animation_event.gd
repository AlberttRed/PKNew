extends Node

#signal cmd_started
#signal cmd_finished

@export var animation:Animation
@export var wait_finished:bool = false

func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SignalManager.CMD.started.emit()
	print(str(name) + " started")
	
	SignalManager.EVENT.play_animation.emit(animation)
	if wait_finished:
		await SignalManager.EVENT.animation_finished

	
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
