class_name BattleSwitchChoice extends BattleChoice

signal pokemonSwitched

var switchInPokemon : BattlePokemon
var switchOutPokemon : BattlePokemon
var battleSpot : BattleSpot

func _init(_selectedPokemon : BattlePokemon):
	self.switchOutPokemon = _selectedPokemon
	self.battleSpot = _selectedPokemon.battleSpot
	#target = _target
	self.priority = 6 # Els canvis de pokemon sempre tenen prioritat 6
	self.type = CONST.BATTLE_ACTIONS.POKEMON
	#GUI.party.pokemonSelected.connect(Callable(self, "setSwitchInPokemon"))
	
#func showParty():
	#await GUI.battle.showParty()

func showParty():
	var selectedIndex = await GUI.battle.showParty()
	if selectedIndex != null:
		switchInPokemon = battleSpot.side.pokemonParty[selectedIndex]
	GUI.battle.cmdPokemon.grab_focus()
	
func switchPokemon():
	if switchInPokemon != null:
		await battleSpot.swapPokemon(switchInPokemon)
		await GUI.get_tree().create_timer(1).timeout
		switchInPokemon = null
	
#func setSwitchInPokemon(pokemonPartyIndex:int):#pokemon:BattlePokemon):
	#switchInPokemon = switchOutPokemon.participant.pokemonTeam[pokemonPartyIndex] #pokemon
