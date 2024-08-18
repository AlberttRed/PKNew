extends BattleMoveAnimation
#----------------------------------------------------
#	Status Paralysis
#----------------------------------------------------
const animName = "Ailments/PARALYSIS"

var sprRay1:Sprite2D
var sprRay2:Sprite2D

func setAnimation(_root, animParams:Dictionary):
	sprRay1 = Sprite2D.new()
	sprRay2 = Sprite2D.new()
	sprRay1.name = "Sprite_Ray1"
	sprRay1.z_index = 2
	sprRay2.name = "Sprite_Ray2"
	sprRay2.z_index = 2
	_root.add_child(sprRay1)
	_root.add_child(sprRay2)
	

func freeAnimation():
	sprRay1.queue_free()
	sprRay2.queue_free()
