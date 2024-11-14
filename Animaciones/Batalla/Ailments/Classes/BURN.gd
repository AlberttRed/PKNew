extends BattleMoveAnimation
#----------------------------------------------------
#	Status Paralysis
#----------------------------------------------------
const animName = "Ailments/BURN"

var animationFrames:Node2D
var sprBurn1:Sprite2D
var sprBurn2:Sprite2D
var sprBurn3:Sprite2D
#
#func setAnimation(_root, animParams:Dictionary):
	#animationFrames = Node2D.new()
	#animationFrames.name = "AnimationFrames"
	#animationFrames.z_index = 2
	#sprBurn1 = Sprite2D.new()
	#sprBurn2 = Sprite2D.new()
	#sprBurn3 = Sprite2D.new()
	#sprBurn1.name = "Burn"
	#sprBurn2.name = "Burn2"
	#sprBurn3.name = "Burn3"
	#animationFrames.add_child(sprBurn1)
	#animationFrames.add_child(sprBurn2)
	#animationFrames.add_child(sprBurn3)
	#_root.add_child(animationFrames)
#
#func freeAnimation():
	#sprBurn1.queue_free()
	#sprBurn2.queue_free()
	#sprBurn3.queue_free()
	#animationFrames.queue_free()
