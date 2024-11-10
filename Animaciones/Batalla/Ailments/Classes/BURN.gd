extends BattleMoveAnimation
#----------------------------------------------------
#	Status Paralysis
#----------------------------------------------------
const animName = "Ailments/BURN"

var sprBurn1:Sprite2D
var sprBurn2:Sprite2D
var sprBurn3:Sprite2D

func setAnimation(_root, animParams:Dictionary):
	sprBurn1 = Sprite2D.new()
	sprBurn2 = Sprite2D.new()
	sprBurn3 = Sprite2D.new()
	sprBurn1.name = "Burn"
	sprBurn2.name = "Burn2"
	sprBurn3.name = "Burn3"
	_root.add_child(sprBurn1)
	_root.add_child(sprBurn2)
	_root.add_child(sprBurn3)

func freeAnimation():
	sprBurn1.queue_free()
	sprBurn2.queue_free()
	sprBurn3.queue_free()
