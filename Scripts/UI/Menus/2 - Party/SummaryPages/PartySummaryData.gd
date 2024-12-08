extends Panel

func open():
	show()

func loadPokemonInfo(pokemon:PokemonInstance):
	$dNumDex.setText(str(pokemon.pkm_id).pad_zeros(3))
	
	$dEspecie.setText(pokemon.Name)
	$Tipos/pTipo1/dTipo1.vframes = 1
	$Tipos/pTipo1/dTipo1.texture = pokemon.type_a.image#frame = pokemon.type_a

	if  pokemon.type_b != null:
		$Tipos/pTipo2.visible = true
		$Tipos/pTipo2/dTipo2.vframes = 1
		$Tipos/pTipo2/dTipo2.texture = pokemon.type_b.image#.frame = pokemon.type_b
	else:
		$Tipos/pTipo2.visible = false
	
	$dEO.setText(pokemon.original_trainer)
	
	$dID.setText(str(pokemon.trainer_id))
	
	$dExperiencia.setText(str(pokemon.totalExp))
	
	$dSigNivel.setText(str(pokemon.nextLevelExpBase - pokemon.totalExp))

	$exp_bar.init(pokemon)
	
func clear():
	$dNumDex.setText("")
	
	$dEspecie.setText("")
	$Tipos/pTipo1/dTipo1.vframes = 2
	$Tipos/pTipo1/dTipo1.texture = ""


	$Tipos/pTipo2.visible = false
	$Tipos/pTipo2/dTipo2.vframes = 2
	$Tipos/pTipo2/dTipo2.texture = ""
	
	$dEO.setText("")
	
	$dID.setText("")
	
	$dExperiencia.setText("")
	
	$dSigNivel.setText("")

	$exp_bar.clear()
