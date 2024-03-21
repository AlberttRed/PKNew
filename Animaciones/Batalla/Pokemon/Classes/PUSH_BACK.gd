extends BattlePokemonAnimation
#----------------------------------------------------
#	Placaje
#----------------------------------------------------
const animName = "Pokemon/PUSH_BACK"

func _init(pokemon:BattlePokemon):
	super(pokemon)


func doAnimation():
	var animPlayer = pokemon.animPlayer
	var position:int = 0
	if pokemon.side.type == CONST.BATTLE_SIDES.ENEMY:
		position = 10
	else:
		position = -10

	var anim: Animation = animPlayer.get_animation(animName)
	#There's only one track (id 0) which modifies Sprite position
	var key_id: int = anim.track_find_key(0, 0.1)
	anim.track_set_key_value(0, key_id, Vector2(position, 0))
	
	animPlayer.play(animName)
	await animPlayer.animation_finished



