extends Resource
class_name MoveCategoryLogic

# Base para lógica de ejecución por categoría de movimiento

var move: BattleMove_Refactor
var user: BattlePokemon_Refactor
var target: BattlePokemon_Refactor
var num_hits: int = 1

func execute() -> Array[ImmediateBattleEffect]:
	return []
