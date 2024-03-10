extends Panel

signal finished

func _ready():
	hide()
	
	
func play(animation : String):
	$AnimationPlayer.play(animation)
	await $AnimationPlayer.animation_finished
	finished.emit()
