extends AnimatedSprite2D

var target
# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0
	#playing = true

func _on_effect_animation_finished():
	print("dep")
	queue_free()


func _on_landing_dust_effect_frame_changed():
	if frame == 1:
		target.unblock_movement()
