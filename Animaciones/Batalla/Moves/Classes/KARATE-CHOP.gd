extends BattleMoveAnimation
#----------------------------------------------------
#	Move Karate Chop
#----------------------------------------------------
const animName = "Moves/KARATE-CHOP"
const animPath = "res://Animaciones/Batalla/Moves/Anim/KARATE-CHOP.res"

const FRAME_ENEMY_POS:Vector2 = Vector2(-60,0)
const FRAME_PLAYER_POS:Vector2 = Vector2(80,0)

#var animationFrames:Node2D
#var sprChop:Sprite2D
#var sprHit:Sprite2D

func init(_move :BattleMove):
	self.move = _move
	self.animation = load(animPath)
	return self

func setAnimation(_root, animParams:Dictionary):
	var target:BattleSpot = move.target.actualTarget#animParams.get('Target')
	#animationFrames = Node2D.new()
	#sprChop = Sprite2D.new()
	#sprHit = Sprite2D.new()
	#sprChop.name = "Chop"
	#sprHit.name = "Hit"
	#animationFrames.name = "AnimationFrames"
	#animationFrames.z_index = 10
	var sprChop:Sprite2D = _root.get_node("AnimationFrames").get_node("Chop")
	var chopPosition:Vector2
	#animationFrames.add_child(sprChop)
	#animationFrames.add_child(sprHit)
	#_root.add_child(animationFrames)
	_root.get_node("AnimationFrames").global_position =  target.global_position #(target.side.position + target.position)

	if target.side.type == CONST.BATTLE_SIDES.ENEMY:
		chopPosition = FRAME_ENEMY_POS
		sprChop.flip_h = false
	else:
		chopPosition = FRAME_PLAYER_POS
		sprChop.flip_h = true
		_root.get_node("AnimationFrames").position += Vector2(0, 20)

	#### Chop:position
	var track_index = animation.find_track("AnimationFrames/Chop:position", Animation.TYPE_VALUE)
	var key_id = animation.track_find_key(track_index, 0.0)
	animation.track_set_key_value(track_index, key_id, chopPosition)

#func freeAnimation():
	#sprChop.queue_free()
	#sprHit.queue_free()
	#animationFrames.queue_free()
