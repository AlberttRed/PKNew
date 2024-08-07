extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que es mostra quan un pokémon rep mal
#----------------------------------------------------

const animName = "Pokemon/HIT"

func _init(pokemon:BattlePokemon):
	super(pokemon)


func doAnimation():
	pokemon.animPlayer.play(animName)#("Common/Battle_StatUp")
	await pokemon.animPlayer.animation_finished


