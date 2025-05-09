class_name BattlePokemon_Refactor

var base_data: PokemonInstance
var ai_controller: BattleIA_Refactor
var participant: BattleParticipant_Refactor
var side: BattleSide_Refactor = null
var battle_spot: BattleSpot_Refactor = null

var in_battle:bool = false
var inBattleParty:bool = false
var controllable: bool
var fainted: bool
var is_wild: bool

func _init(_pokemon: PokemonInstance, _IA: BattleIA_Refactor = null):
	base_data = _pokemon

	if base_data.hp_actual > 0:
		fainted = false
	else:
		fainted = true

	setIA(_IA)

func set_battle_spot(spot: BattleSpot_Refactor) -> void:
	battle_spot = spot
	
func setIA(_IA:BattleIA_Refactor):
	if _IA != null:
		var pkmnIA:BattleIA_Refactor = _IA.duplicate()
		if !pkmnIA.pokemon_assigned():
			pkmnIA.assign_pokemon(self)
		self.ai_controller = pkmnIA
		
func _to_string() -> String:
	return "patata"

func get_back_sprite():
	#var texture:Texture2D = ImageTexture.new().create_from_image(instance.battle_back_sprite.atlas.get_image().get_region(instance.battle_back_sprite.region))
	#texture.set_size_override(texture.get_size())
	return base_data.battle_back_sprite
	
func get_front_sprite():
	#var texture:Texture2D = ImageTexture.new().create_from_image(instance.battle_front_sprite.atlas.get_image().get_region(instance.battle_front_sprite.region))
	#texture.set_size_override(texture.get_size())
	return base_data.battle_front_sprite
	

func get_hp() -> int:
	return base_data.hp_actual
	
func get_name() -> String:
	if !base_data.nickname.is_empty():
		return base_data.nickname
	else:
		return base_data.Name

func get_level() -> int:
	return base_data.level
