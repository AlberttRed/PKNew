extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que es mostra quan cures un pokemon en combat
#----------------------------------------------------

const animName = "Pokemon/HEAL"

func _init(pokemon:BattlePokemon):
	super(pokemon)


func doAnimation():
	pokemon.animPlayer.play(animName)
	await pokemon.animPlayer.animation_finished
