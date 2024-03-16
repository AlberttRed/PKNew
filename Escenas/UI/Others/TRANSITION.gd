extends Panel

signal finished
@onready var animationPlayer:AnimationPlayer = $AnimationPlayer

func _ready():
	hide()
	
	
func play(animation : String):
	animationPlayer.play(animation)
	await animationPlayer.animation_finished
	finished.emit()
