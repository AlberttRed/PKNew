extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que es mostra quan un pokemon es derrotat.
#	L'sprite baixa cap avall i desapareix
#----------------------------------------------------

const animName = "Pokemon/DEFEATED"

func _init(pokemon:BattlePokemon):
	super(pokemon)


func doAnimation():
	pokemon.animPlayer.play(animName)
	await pokemon.animPlayer.animation_finished


