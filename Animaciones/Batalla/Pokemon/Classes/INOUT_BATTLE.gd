extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que fa apareixer i desapareixer el pokemon quan surt de la pokeball
#----------------------------------------------------

const animName = "Pokemon/INOUT_BATTLE"

func _init(pokemon:BattlePokemon):
	super(pokemon)


func doAnimation():
	pokemon.playAnimation(animName)
	await pokemon.animPlayer.animation_finished
