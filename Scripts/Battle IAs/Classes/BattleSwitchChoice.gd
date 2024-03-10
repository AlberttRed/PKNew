class_name BattleSwitchChoice extends BattleChoice

var selectedPokemon : BattlePokemon

func _init(_selectedPokemon : BattlePokemon, _target : Array[BattlePokemon]):
	selectedPokemon = _selectedPokemon
	target = _target
	priority = 6 # Els canvis de pokemon sempre tenen prioritat 6
	type = CONST.BATTLE_ACTIONS.POKEMON
