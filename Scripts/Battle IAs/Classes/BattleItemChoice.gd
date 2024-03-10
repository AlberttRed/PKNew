class_name BattleItemChoice extends BattleChoice

var selectedItem # Falta crear la classe BattleItem, que indicarà l'item seleccionat

func _init(_selectedItem, _target : Array[BattlePokemon]):
	selectedItem = _selectedItem
	target = _target
	priority = 6 # Els canvis de pokemon sempre tenen prioritat 6
	type = CONST.BATTLE_ACTIONS.MOCHILA
