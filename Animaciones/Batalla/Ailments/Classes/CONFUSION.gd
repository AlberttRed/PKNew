extends BattleMoveAnimation
#----------------------------------------------------
#	Status Confusion
#----------------------------------------------------
const animName = "Ailments/CONFUSION"

var nodeGroup:Node2D

var sprBird1:Sprite2D
var sprBird2:Sprite2D
var sprBird3:Sprite2D
var sprBird4:Sprite2D
var sprBird5:Sprite2D


func setAnimation(_root, animParams:Dictionary):
	nodeGroup = Node2D.new()
	nodeGroup.name = "FramesGroup"
	nodeGroup.z_as_relative = false
	nodeGroup.position = Vector2(-16,-20)
	
	sprBird1 = Sprite2D.new()
	sprBird2 = Sprite2D.new()
	sprBird3 = Sprite2D.new()
	sprBird4 = Sprite2D.new()
	sprBird5 = Sprite2D.new()
	sprBird1.name = "Bird1"
	sprBird2.name = "Bird2"
	sprBird3.name = "Bird3"
	sprBird4.name = "Bird4"
	sprBird5.name = "Bird5"

	nodeGroup.add_child(sprBird1)
	nodeGroup.add_child(sprBird2)
	nodeGroup.add_child(sprBird3)
	nodeGroup.add_child(sprBird4)
	nodeGroup.add_child(sprBird5)
	_root.sprite.add_child(nodeGroup)

func freeAnimation():
	sprBird1.queue_free()
	sprBird2.queue_free()
	sprBird3.queue_free()
	sprBird4.queue_free()
	sprBird5.queue_free()
	nodeGroup.queue_free()
