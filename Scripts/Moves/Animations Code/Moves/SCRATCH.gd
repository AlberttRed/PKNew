extends BattleMoveAnimation


func setAnimation(_root, animParams:Dictionary):
		print("Do the animation bro")
		
		var spr1 = Sprite2D.new()
		spr1.name = "move"
		#_target.battleNode.get_node("Sprite").add_child(spr1)
#
		#_target.animPlayer.play("Moves/SCRATCH")
		#await _target.animPlayer.animation_finished
		spr1.queue_free()
