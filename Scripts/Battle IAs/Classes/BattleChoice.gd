class_name BattleChoice

var target : Array[BattlePokemon]
var priority : int = 0 # Ordre de prioritat en la que s'executarà aquesta opció
var type : CONST.BATTLE_ACTIONS
#
#func _init(_move : BattleMove, _target : Array[BattlePokemon], _damage : int = 0):
#	move = _move
#	target = _target
#	damage = _damage
