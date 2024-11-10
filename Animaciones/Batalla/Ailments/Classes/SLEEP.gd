extends BattleMoveAnimation
#----------------------------------------------------
#	Status Sleep
#----------------------------------------------------
const animName = "Ailments/SLEEP"

var zet1:Sprite2D
var zet2:Sprite2D

func setAnimation(_root, animParams:Dictionary):
	zet1 = Sprite2D.new()
	zet2 = Sprite2D.new()
	zet1.name = "Zet"
	zet1.z_index = 2
	zet2.name = "Zet2"
	zet2.z_index = 2
	_root.add_child(zet1)
	_root.add_child(zet2)
	

func freeAnimation():
	zet1.queue_free()
	zet2.queue_free()
