extends BattleCommonAnimation
#----------------------------------------------------
#	Animació que llança la pokeball de l'entrenador per treure el pokémon
#----------------------------------------------------
const animName = "General/ENEMY_THROWBALL"
var spr1:Sprite2D

func setAnimation(_root):
	root = _root
	spr1 = Sprite2D.new()
	spr1.name = "Pokeball"
	#spr1.z_index = 0
	#spr1.hide()
	root.add_child(spr1)

func freeAnimation():
	spr1.queue_free()
