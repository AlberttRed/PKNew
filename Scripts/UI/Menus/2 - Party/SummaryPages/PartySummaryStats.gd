extends Panel

func open():
	show()
	
func loadPokemonInfo(pokemon:PokemonInstance):
	$dPS.setText(str(pokemon.hp_actual) + "/" + str(pokemon.hp_total))

	$health_bar.init(pokemon)

	$ValueStats/dAtaque.setText(pokemon.attack)
	
	$ValueStats/dDefensa.setText(str(pokemon.defense))
	
	$ValueStats/dAtEsp.setText(str(pokemon.special_attack)) 
	
	$ValueStats/dDefEsp.setText(str(pokemon.special_defense))

	$ValueStats/dVelocidad.setText(str(pokemon.speed)) 

	$dHabilidad.setText(CONST.AbilitiesName[pokemon.ability_id])

	$DescHabilidad.setText(CONST.AbilitiesDesc[pokemon.ability_id])

func clear():
	$dPS.setText("")

	$health_bar.clear()
	
	$ValueStats/dAtaque.setText("")

	$ValueStats/dDefensa.setText("")

	$ValueStats/dAtEsp.setText("")

	$ValueStats/dDefEsp.setText("")

	$ValueStats/dVelocidad.setText("")

	$dHabilidad.setText("")

	$DescHabilidad.setText("")
