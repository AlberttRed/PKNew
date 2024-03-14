class_name BattleMoveChoice extends BattleChoice

var move : BattleMove
var damage : int

func _init(_move : BattleMove, _target : Array[BattlePokemon], _damage : int = 0):
	move = _move
	target = _target
	damage = _damage
	print(move.Name)
	priority = _move.priority # La prioritat del movechoice serà la prioritat del moviment
	type = CONST.BATTLE_ACTIONS.LUCHAR
