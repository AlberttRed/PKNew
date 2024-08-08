extends BattleCommonAnimation
#----------------------------------------------------
#	Animació que llança la pokeball de l'entrenador per treure el pokémon
#----------------------------------------------------
const animName = "General/PLAYER_THROWBALL"

func setAnimation(_root, animParams:Dictionary):#_init():
	root = _root
	var side:CONST.BATTLE_SIDES = animParams.get('Side')
		
	var hpBar:HPBar = root
	var initialPosition:Vector2 = hpBar.position
	var finalPosition:Vector2
	
	if side == CONST.BATTLE_SIDES.PLAYER:
		finalPosition = initialPosition - Vector2(244, 0)
	elif side == CONST.BATTLE_SIDES.ENEMY:
		finalPosition = initialPosition + Vector2(244, 0)
	
	# Posicion incial
	var track_index = find_track(".:position", Animation.TYPE_VALUE)
	var key_id: int = track_find_key(track_index, 0.00)
	track_set_key_value(track_index, key_id, initialPosition)

	# Posicion final
	track_index = find_track(".:position", Animation.TYPE_VALUE)
	key_id = track_find_key(track_index, 0.50)
	track_set_key_value(track_index, key_id, finalPosition)

func freeAnimation():
	pass


