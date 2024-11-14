extends BattleMoveAnimation
#----------------------------------------------------
#	Status Paralysis
#----------------------------------------------------
const animName = "Ailments/PARALYSIS"

var animationFrames:Node2D
var sprRay1:Sprite2D
var sprRay2:Sprite2D

func setAnimation(_root, animParams:Dictionary):
	#animationFrames = Node2D.new()
	#animationFrames.name = "AnimationFrames"
	#animationFrames.z_index = 2
	#sprRay1 = Sprite2D.new()
	#sprRay2 = Sprite2D.new()
	#sprRay1.name = "Ray1"
	#sprRay1.z_index = 2
	#sprRay2.name = "Ray2"
	#sprRay2.z_index = 2
	#animationFrames.add_child(sprRay1)
	#animationFrames.add_child(sprRay2)
	#_root.add_child(animationFrames)
	pass

#func freeAnimation():
	#sprRay1.queue_free()
	#sprRay2.queue_free()
	#animationFrames.queue_free()
