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
	SIGNALS.CMD.started.emit()
	print(str(name) + " started")
	
	SIGNALS.EVENT.play_animation.emit(animation)
	if wait_finished:
		await SIGNALS.EVENT.animation_finished

	
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
