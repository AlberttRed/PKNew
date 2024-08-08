extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que es mostra quan un pokemon es derrotat.
#	L'sprite baixa cap avall i desapareix
#----------------------------------------------------

const animName = "Pokemon/DEFEATED"


func setAnimation(_root, animParams:Dictionary):
	var side:CONST.BATTLE_SIDES = animParams.get('Side')
	var defeat_position:int = 0
	#Segons si el pokemon esta al bando del jugador o no, l altura per desapareixer es diferent
	if side == CONST.BATTLE_SIDES.PLAYER:
		defeat_position = 75
	else:
		defeat_position = 48
		
	var track_id: int = find_track("Sprite:material:shader_parameter/cutoff", 0)
	var key_id: int = track_find_key(track_id, 0.0)
	track_set_key_value(track_id, key_id, defeat_position)

func freeAnimation():
	pass
