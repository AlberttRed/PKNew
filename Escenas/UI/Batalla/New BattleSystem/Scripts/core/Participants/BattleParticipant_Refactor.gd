extends RefCounted

class_name BattleParticipant_Refactor

var trainer_id: int = -1  # -1 o algún valor especial para salvajes
var is_player: bool = false
var name: String = "":
	get:
		return name if name != null else ""
var ai_controller: BattleIA_Refactor = null  # null si es jugador
var sprite_path: String = ""  # Opcional, si usás esto para mostrar el entrenador
var is_trainer: bool = true  # Nuevo flag, por compatibilidad futura
var side: BattleSide_Refactor = null  # Se asigna desde el add_participant()

# Internal storage for the participant's battle team.
# DO NOT modify this directly. Use add_pokemon or add_pokemon_team.
var _pokemon_team: Array[BattlePokemon_Refactor] = []

# Public property with validation on assignment.
var pokemon_team: Array[BattlePokemon_Refactor]:
	get:
		return _pokemon_team
	set(value):
		_pokemon_team.clear()
		for pk in value:
			add_pokemon(pk)

func _init(_pokemon_team: Array[BattlePokemon_Refactor] = []):
	self.add_pokemon_team(_pokemon_team)
#func _init(trainer_id: int, is_player := false, name := "", team := []):
	#self.trainer_id = trainer_id
	#self.is_player = is_player
	#self.name = name
	#self.pokemon_team = team


# Adds a single BattlePokemon to the participant's team.
func add_pokemon(pokemon: BattlePokemon_Refactor) -> void:
	if pokemon.ai_controller == null:
		pokemon.setIA(ai_controller)
	pokemon.participant = self
	_pokemon_team.append(pokemon)

# Adds multiple BattlePokemon at once.
func add_pokemon_team(pokemon_list: Array[BattlePokemon_Refactor]) -> void:
	for pk in pokemon_list:
		add_pokemon(pk)

func decide_action_for(pokemon: BattlePokemon_Refactor) -> BattleChoice_Refactor:
	if ai_controller:
		return await ai_controller.decide_action(pokemon)
	return await pokemon.decide_random_action()  # fallback aleatorio


func get_active_pokemons() -> Array[BattlePokemon_Refactor]:
	return pokemon_team.filter(func(pk): return pk.in_battle and not pk.fainted)
