extends Panel

func open():
	show()
	
func loadPokemonInfo(pokemon:PokemonInstance):
	$dPS.text = str(pokemon.hp_actual) + "/" + str(pokemon.hp_total)
	$dPS/Outline.text = str(pokemon.hp_actual) + "/" + str(pokemon.hp_total)
	
	$health_bar.init(pokemon)
	
	$ValueStats/dAtaque.text = str(pokemon.attack) 
	$ValueStats/dAtaque/Outline.text = str(pokemon.attack) 
	
	$ValueStats/dDefensa.text = str(pokemon.defense) 
	$ValueStats/dDefensa/Outline.text = str(pokemon.defense) 
	
	$ValueStats/dAtEsp.text = str(pokemon.special_attack) 
	$ValueStats/dAtEsp/Outline.text = str(pokemon.special_attack) 
	
	$ValueStats/dDefEsp.text = str(pokemon.special_defense)
	$ValueStats/dDefEsp/Outline.text = str(pokemon.special_defense) 
	
	$ValueStats/dVelocidad.text = str(pokemon.speed) 
	$ValueStats/dVelocidad/Outline.text = str(pokemon.speed) 

	$dHabilidad.text = CONST.AbilitiesName[pokemon.ability_id]
	$dHabilidad/Outline.text = CONST.AbilitiesName[pokemon.ability_id]
	
	$DescHabilidad.text = CONST.AbilitiesDesc[pokemon.ability_id]
	$DescHabilidad/Outline.text = CONST.AbilitiesDesc[pokemon.ability_id]

func clear():
	$dPS.text = ""
	$dPS/Outline.text = ""
	
	$health_bar.clear()
	
	$ValueStats/dAtaque.text = ""
	$ValueStats/dAtaque/Outline.text = ""
	
	$ValueStats/dDefensa.text = ""
	$ValueStats/dDefensa/Outline.text = ""
	
	$ValueStats/dAtEsp.text = ""
	$ValueStats/dAtEsp/Outline.text = ""
	
	$ValueStats/dDefEsp.text = ""
	$ValueStats/dDefEsp/Outline.text = ""
	
	$ValueStats/dVelocidad.text = ""
	$ValueStats/dVelocidad/Outline.text = ""

	$dHabilidad.text = ""
	$dHabilidad/Outline.text = ""
	
	$DescHabilidad.text = ""
	$DescHabilidad/Outline.text = ""
