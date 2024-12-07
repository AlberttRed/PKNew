extends Panel

func open():
	show()
	
func loadPokemonInfo(pokemon:PokemonInstance):
	$Naturaleza.text = CONST.NaturesName[pokemon.nature_id] + "."
	$Naturaleza/Outline.text = CONST.NaturesName[pokemon.nature_id] + "."
	
	$Labels/FechaCaptura.text = pokemon.capture_date
	$Labels/FechaCaptura/Outline.text = pokemon.capture_date
	
	$Labels/RutaCaptura.text = pokemon.capture_route
	$Labels/RutaCaptura/Outline.text = pokemon.capture_route
	
	$Labels/NivelCaptura.text = "Encontrado con Nv. " + str(pokemon.capture_level) + "."
	$Labels/NivelCaptura/Outline.text = "Encontrado con Nv. " + str(pokemon.capture_level) + "."
	
	$DescNaturaleza.text = pokemon.personality
	$DescNaturaleza/Outline.text = pokemon.personality

func clear():
	$Naturaleza.text = ""
	$Naturaleza/Outline.text = ""
	
	$Labels/FechaCaptura.text = ""
	$Labels/FechaCaptura/Outline.text = ""
	
	$Labels/RutaCaptura.text = ""
	$Labels/RutaCaptura/Outline.text = ""
	
	$Labels/NivelCaptura.text = ""
	$Labels/NivelCaptura/Outline.text = ""
	
	$DescNaturaleza.text = ""
	$DescNaturaleza/Outline.text = ""
