extends Panel

func open():
	show()

func loadPokemonInfo(pokemon:PokemonInstance):
	$dNumDex.text = str(pokemon.pkm_id).pad_zeros(3)
	$dNumDex/Outline.text = str(pokemon.pkm_id).pad_zeros(3)
	
	$dEspecie.text = pokemon.Name
	$dEspecie/Outline.text = pokemon.Name
	$Tipos/pTipo1/dTipo1.vframes = 1
	$Tipos/pTipo1/dTipo1.texture = pokemon.type_a.image#frame = pokemon.type_a

	if  pokemon.type_b != null:
		$Tipos/pTipo2.visible = true
		$Tipos/pTipo2/dTipo2.vframes = 1
		$Tipos/pTipo2/dTipo2.texture = pokemon.type_b.image#.frame = pokemon.type_b
	else:
		$Tipos/pTipo2.visible = false
	
	$dEO.text = pokemon.original_trainer
	$dEO/Outline.text = pokemon.original_trainer
	
	$dID.text = str(pokemon.trainer_id)
	$dID/Outline.text = str(pokemon.trainer_id)
	
	$dExperiencia.text = str(pokemon.totalExp)
	$dExperiencia/Outline.text = str(pokemon.totalExp)
	
	$dSigNivel.text = str(pokemon.nextLevelExpBase - pokemon.totalExp)
	$dSigNivel/Outline.text = str(pokemon.nextLevelExpBase - pokemon.totalExp)

	$exp_bar.init(pokemon)
	
func clear():
	$dNumDex.text = ""
	$dNumDex/Outline.text = ""
	
	$dEspecie.text = ""
	$dEspecie/Outline.text = ""
	$Tipos/pTipo1/dTipo1.vframes = 2
	$Tipos/pTipo1/dTipo1.texture = ""


	$Tipos/pTipo2.visible = false
	$Tipos/pTipo2/dTipo2.vframes = 2
	$Tipos/pTipo2/dTipo2.texture = ""
	
	$dEO.text = ""
	$dEO/Outline.text = ""
	
	$dID.text = ""
	$dID/Outline.text = ""
	
	$dExperiencia.text = ""
	$dExperiencia/Outline.text = ""
	
	$dSigNivel.text = ""
	$dSigNivel/Outline.text = ""

	$exp_bar.clear()
