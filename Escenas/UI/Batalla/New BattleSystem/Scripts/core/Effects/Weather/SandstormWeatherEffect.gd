extends BattleWeatherEffect_Refactor
class_name SandstormWeatherEffect

func _init():
	scope = Scope.FIELD
	
func apply_at_end_turn(controller):
	print("Tormenta arena hace daño a todos los Pokémon que no son Roca, Tierra o Acero")
