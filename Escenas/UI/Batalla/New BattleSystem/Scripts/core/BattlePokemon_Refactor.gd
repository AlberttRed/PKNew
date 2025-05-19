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
var battle_moves: Array[BattleMove_Refactor] = []

var hp: int
var total_hp: int
var attack: int
var defense: int
var sp_attack: int
var sp_defense: int
var speed: int

var ability: Ability = null

var accuracy_stage: int = 0
var evasion_stage: int = 0
var critical_stage: int = 0

var status: String = ""
var status_turns: int = 0

var selectedBattleChoice: BattleChoice_Refactor

func _init(_pokemon: PokemonInstance, _IA: BattleIA_Refactor = null):
	base_data = _pokemon
	controllable = (_IA == null)
	hp = base_data.hp_actual
	total_hp = base_data.getHPStat()
	attack = base_data.getAttackStat()
	defense = base_data.getDefenseStat()
	sp_attack = base_data.getSpAttackStat()
	sp_defense = base_data.getSpDefenseStat()
	speed = base_data.getSpeedStat()
	ability = base_data.get_ability_resource()

	#status = base_data.status
	#status_turns = base_data.status_turns
	fainted = base_data.hp_actual <= 0
	

	setIA(_IA)

func set_battle_spot(spot: BattleSpot_Refactor) -> void:
	battle_spot = spot
	
func setIA(_IA:BattleIA_Refactor):
	if _IA != null:
		var pkmnIA:BattleIA_Refactor = _IA.duplicate()
		if !pkmnIA.pokemon_assigned():
			pkmnIA.assign_pokemon(self)
		self.ai_controller = pkmnIA

func init_turn() -> void:
	selectedBattleChoice = null
	# Si más adelante agregas efectos temporales, pueden resetearse aquí
	
func _to_string() -> String:
	return "patata"
	
func get_type1() -> Type:
	return base_data.type_a as Type

func get_type2() -> Type:
	return base_data.type_b as Type
	
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

func get_attack() -> int:
	return base_data.attack

func get_defense() -> int:
	return base_data.defense

func get_sp_attack() -> int:
	return base_data.special_attack

func get_sp_defense() -> int:
	return base_data.special_defense

func get_speed() -> int:
	return base_data.speed
	
func get_name() -> String:
	if !base_data.nickname.is_empty():
		return base_data.nickname
	else:
		return base_data.Name

func get_level() -> int:
	return base_data.level
	
func is_fainted() -> bool:
	return get_hp() <= 0

func get_opponent_side() -> BattleSide_Refactor:
	return side.opponent_side

func get_available_moves() -> Array[BattleMove_Refactor]:
	if battle_moves.is_empty():
		prepare_battle_moves()
	return battle_moves

func prepare_battle_moves():
	battle_moves.clear()
	for move_instance:MoveInstance in base_data.movements:
		battle_moves.append(move_instance.to_battle_move(self))

func decide_random_action() -> BattleChoice_Refactor:
	var moves = get_available_moves()
	if moves.is_empty():
		return BattleChoice_Refactor.new()  # fallback

	var index = randi() % moves.size()
	var move = moves[index]

	var choice = BattleMoveChoice_Refactor.new()
	choice.move_index = index
	choice.pokemon = self

	var target_handler = BattleTarget.new(move)
	await target_handler.select_targets()
	choice.target_handler = target_handler

	return choice

func take_damage(damage: MoveImpactResult.Damage) -> void:
	hp -= damage.amount
	hp = max(hp, 0)




#func select_action() -> void:
	#if controllable:
		#await BattleUIRef.actions_menu.show_for(self)
		#selectedBattleChoice = await actionSelected
		#BattleUIRef.actions_menu.hide()
	#else:
		#selectedBattleChoice = decide_ai_action()
