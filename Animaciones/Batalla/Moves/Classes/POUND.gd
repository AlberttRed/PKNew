extends BattleMoveAnimation
#----------------------------------------------------
#	Placaje
#----------------------------------------------------
const animPath = "res://Animaciones/Batalla/Moves/Anim/POUND.res"

#var animationFrames:Node2D
#var sprHit:Sprite2D

func init(_move :BattleMove):
	self.move = _move
	self.animation = load(animPath)
	return self

func setAnimation(_root, animParams:Dictionary):
	var target:BattleSpot = move.target.actualTarget#animParams.get('Target')
	var targetPath = _root.get_path_to(target)
	_root.get_node("AnimationFrames").global_position =  target.global_position

#### PoemonNode:playAnimation
	var track_index = animation.add_track(Animation.TYPE_METHOD)
	animation.track_set_path(track_index, targetPath)
	animation.track_insert_key(track_index, 0.1, {"method": "playAnimation","args": ["PUSH_BACK"]})
