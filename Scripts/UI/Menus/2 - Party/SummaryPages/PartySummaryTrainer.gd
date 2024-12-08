extends Panel

func open():
	show()
	
func loadPokemonInfo(pokemon:PokemonInstance):
	$Naturaleza.setText(CONST.NaturesName[pokemon.nature_id] + ".")

	$Labels/FechaCaptura.setText(pokemon.capture_date)

	$Labels/RutaCaptura.setText(pokemon.capture_route)

	$Labels/NivelCaptura.setText("Encontrado con Nv. " + str(pokemon.capture_level) + ".")

	$DescNaturaleza.setText(pokemon.personality)

func clear():
	$Naturaleza.setText("")

	$Labels/FechaCaptura.setText("")

	$Labels/RutaCaptura.setText("")

	$Labels/NivelCaptura.setText("")

	$DescNaturaleza.setText("")
