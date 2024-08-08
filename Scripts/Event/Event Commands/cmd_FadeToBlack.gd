extends Node

func _init():
	pass

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func exec():
	SignalManager.CMD.started.emit()
	print(str(name) + " started")
	GLOBAL.PLAYER.block_movement()
	GLOBAL.SCENE_MANAGER.animationPlayer.play("FadeToBlack")
	
	await GLOBAL.SCENE_MANAGER.animationPlayer.animation_finished
	GLOBAL.SCENE_MANAGER.faded = true
	print(str(name) + " finished")
	SignalManager.CMD.finished.emit()
