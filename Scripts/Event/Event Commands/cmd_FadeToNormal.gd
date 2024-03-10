extends Node

func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SIGNALS.CMD.started.emit()
	print(str(name) + " started")
	
	GLOBAL.SCENE_MANAGER.animationPlayer.play("FadeToNormal")
	
	await GLOBAL.SCENE_MANAGER.animationPlayer.animation_finished
	GLOBAL.SCENE_MANAGER.faded = false
	print(str(name) + " finished")
	GLOBAL.PLAYER.unblock_movement()
	SIGNALS.CMD.finished.emit()
