class_name BattleRules

var type : CONST.BATTLE_TYPES = CONST.BATTLE_TYPES.NONE # Indica si es un combat contra pokémon Salvatge o un Entrenador
var mode : CONST.BATTLE_MODES = CONST.BATTLE_MODES.NONE # Indica si es un combat individual, doble o triple (triple de moment no es tindrà en compte)


func _init(_battleType : CONST.BATTLE_TYPES, _battleMode : CONST.BATTLE_MODES):
	type = _battleType
	mode = _battleMode

func queue_free():
	free()
