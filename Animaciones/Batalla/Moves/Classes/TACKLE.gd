extends BattleMoveAnimation
#----------------------------------------------------
#	Placaje
#----------------------------------------------------
const animPath = "res://Animaciones/Batalla/Moves/Anim/TACKLE.res"

#var animationFrames:Node2D
#var sprHit:Sprite2D

func init(_move :BattleMove):
	self.move = _move
	self.animation = load(animPath)
	return self

func setAnimation(_root, animParams:Dictionary):
#func doAnimation(target : BattleSpot):
	var target:BattleSpot = move.target.actualTarget#animParams.get('Target')
	#var animPlayer = origin.animPlayer
	#var targetAnimPlayer = target.animPlayer
	#animationFrames = Node2D.new()
	#sprHit = Sprite2D.new()
	var targetPath = _root.get_path_to(target)
	
	var framePosition:Vector2 = Vector2(0,0)
	var pushPosition:Vector2
	if target.side.type == CONST.BATTLE_SIDES.ENEMY:
		pushPosition = Vector2(50,0)
		#framePosition = FRAME_ENEMY_POS
	else:
		pushPosition = Vector2(-50,0)
		#framePosition = FRAME_PLAYER_POS
	
	#animationFrames.name = "AnimationFrames"
	#animationFrames.z_index = 10
	#sprHit.name = "Hit"
	#sprHit.z_index = 10
	#sprHit.visible = false
	#animationFrames.add_child(sprHit)
	#_root.add_child(animationFrames)
	_root.get_node("AnimationFrames").global_position =  target.global_position
	#var animation: Animation =  self#animPlayer.get_animation(animName)

#### Sprite:position
	var track_index = animation.find_track("Sprite:position", Animation.TYPE_VALUE)
	var key_id: int = animation.track_find_key(track_index, 0.15)
	animation.track_set_key_value(track_index, key_id, pushPosition)

#### PoemonNode:playAnimation
	track_index = animation.add_track(Animation.TYPE_METHOD)
	animation.track_set_path(track_index, targetPath)
	animation.track_insert_key(track_index, 0.2, {"method": "playAnimation","args": ["PUSH_BACK"]})

#### Sprite2D:position
	#track_index = animation.add_track(Animation.TYPE_VALUE)
	#animation.track_set_path(track_index, "Sprite2D:position")

	track_index = animation.find_track("AnimationFrames/Hit:position", Animation.TYPE_VALUE)
	key_id = animation.track_find_key(track_index, 0.2)
	animation.track_set_key_value(track_index, key_id, framePosition)
	key_id = animation.track_find_key(track_index, 0.25)
	animation.track_set_key_value(track_index, key_id, framePosition-Vector2(5,0))
	key_id = animation.track_find_key(track_index, 0.3)
	animation.track_set_key_value(track_index, key_id, framePosition)
	key_id = animation.track_find_key(track_index, 0.35)
	animation.track_set_key_value(track_index, key_id, framePosition+Vector2(5,0))
	key_id = animation.track_find_key(track_index, 0.4)
	animation.track_set_key_value(track_index, key_id, framePosition)
	
	#animPlayer.play(animName)
	#await animPlayer.animation_finished
	#spr1.queue_free()
#
#func freeAnimation():
	#sprHit.queue_free()
	#animationFrames.queue_free()


#func setOriginTarget(target:BattlePokemon, anim:Animation):
	#var originName = origin.battleNode.name
	#var targetName = target.battleNode.name
	#var targetPath: String = origin.battleNode.get_path_to(target.battleNode)
	#for i:int in range(anim.get_track_count()):
		#pass
	#
	#
