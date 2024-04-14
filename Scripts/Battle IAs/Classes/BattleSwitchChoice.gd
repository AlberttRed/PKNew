class_name BattleSwitchChoice extends BattleChoice

signal pokemonSwitched

var switchInPokemon : PokemonInstance
var switchOutPokemon : BattlePokemon

func _init(_selectedPokemon : BattlePokemon):
	self.switchOutPokemon = _selectedPokemon
	#target = _target
	self.priority = 6 # Els canvis de pokemon sempre tenen prioritat 6
	self.type = CONST.BATTLE_ACTIONS.POKEMON
	GUI.party.pokemonSelected.connect(Callable(self, "setSwitchInPokemon"))
	
func showParty():
	await GUI.battle.showParty()
	
func switchPokemon():
	switchOutPokemon.swapPokemon(switchInPokemon)
	await GUI.get_tree().create_timer(1).timeout
	
func setSwitchInPokemon(pokemon:PokemonInstance):
	switchInPokemon = pokemon
