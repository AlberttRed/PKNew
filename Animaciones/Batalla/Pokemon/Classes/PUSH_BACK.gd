extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que fa retrocedir el pokemon cap enrere i llavors torna a la posició original
#	Utilitzat en animación com TACKLE
#----------------------------------------------------

const animName = "Pokemon/PUSH_BACK"

#func _init(pokemon:BattlePokemon):
	#super(pokemon)


func setAnimation(_root, animParams:Dictionary):#doAnimation():
	var pokemon:BattlePokemon = _root.activePokemon
	var position:int = 0
	if pokemon.side.type == CONST.BATTLE_SIDES.ENEMY:
		position = 10
	else:
		position = -10

	var anim: Animation = self# animPlayer.get_animation(animName)
	#There's only one track (id 0) which modifies Sprite position
	var key_id: int = anim.track_find_key(0, 0.1)
	anim.track_set_key_value(0, key_id, Vector2(position, 0))
	

func freeAnimation():
	pass




