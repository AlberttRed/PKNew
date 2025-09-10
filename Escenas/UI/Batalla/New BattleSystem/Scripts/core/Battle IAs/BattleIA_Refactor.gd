extends Resource

class_name BattleIA_Refactor

var pokemon : BattlePokemon_Refactor = null

func _init(_active_pokemon : BattlePokemon_Refactor = null):
	pokemon = _active_pokemon
	
func assign_pokemon(_active_pokemon : BattlePokemon_Refactor = null):
	pokemon = _active_pokemon

func pokemon_assigned():
	return pokemon != null	
	
func selectAction():
	pass

func selectMove():
	pass
	
func selectTargets():
	pass
	
func selectNextPokemon():
	pass
