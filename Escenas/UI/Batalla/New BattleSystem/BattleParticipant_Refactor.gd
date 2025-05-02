extends RefCounted

class_name BattleParticipant_Refactor

var trainer_id: int = -1  # -1 o algún valor especial para salvajes
var is_player: bool = false
var name: String = ""
var pokemon_team: Array[PokemonInstance] = []
var ai_controller: BattleIA = null  # null si es jugador
var sprite_path: String = ""  # Opcional, si usás esto para mostrar el entrenador
var is_trainer: bool = true  # Nuevo flag, por compatibilidad futura
var side: BattleSide_Refactor = null  # Se asigna desde el add_participant()

#func _init(trainer_id: int, is_player := false, name := "", team := []):
	#self.trainer_id = trainer_id
	#self.is_player = is_player
	#self.name = name
	#self.pokemon_team = team
