extends Control

class_name BattleUI_Refactor

@onready var field_ui:FieldUI = $FieldUI
@onready var party_ui = $PartyUI
@onready var action_menu = $ActionsMenu
@onready var message_box = $MessageBox
@onready var move_menu = $MovesMenu

func _ready() -> void:
	visible = false

func setup_for_sides(player_side: BattleSide_Refactor, enemy_side: BattleSide_Refactor, rules: BattleRules) -> void:
	field_ui.setup_spots(player_side, enemy_side, rules)
	field_ui.position_battlespots_for_mode(rules.mode)
	#party_ui.load_party(player_side.pokemonParty)




func show_trainer_sprites():
	$FieldUI/PlayerBase/TrainerA.visible = true
	$FieldUI/EnemyBase/TrainerA.visible = true  # O TrainerB si hay más de uno
	# Mostrar los sprites de los entrenadores en pantalla

func show_enemy_pokemon(pokemons: Array[BattlePokemon_Refactor], rules: BattleRules):
	if pokemons.size() >= 1:
		var spot_a: BattleSpot_Refactor = $FieldUI/EnemyBase/PokemonSpotA
		spot_a.load_active_pokemon(pokemons[0], rules)

	if pokemons.size() >= 2:
		var spot_b: BattleSpot_Refactor = $FieldUI/EnemyBase/PokemonSpotB
		spot_b.load_active_pokemon(pokemons[1], rules)
	# Mostrar el sprite del Pokémon enemigo

func show_player_pokemon(pokemons: Array[BattlePokemon_Refactor], rules: BattleRules):
	if pokemons.size() >= 1:
		$FieldUI/PlayerBase/PokemonSpotA.load_active_pokemon(pokemons[0], rules)
	if pokemons.size() >= 2:
		$FieldUI/PlayerBase/PokemonSpotB.load_active_pokemon(pokemons[1], rules)
	# Mostrar el sprite del Pokémon del jugador

func show_enemy_hp_bar(pokemons: Array[BattlePokemon_Refactor]):
	if pokemons.size() >= 1:
		$FieldUI/EnemyBase/HPBarA.visible = true
	if pokemons.size() >= 2:
		$FieldUI/EnemyBase/HPBarB.visible = true
	# Mostrar la barra de vida del Pokémon enemigo

func show_player_hp_bar(pokemons: Array[BattlePokemon_Refactor]):
	if pokemons.size() >= 1:
		$FieldUI/PlayerBase/HPBarA.visible = true
	if pokemons.size() >= 2:
		$FieldUI/PlayerBase/HPBarB.visible = true
	# Mostrar la barra de vida del Pokémon del jugador

func show_message(text: String):
	pass
	# Mostrar un mensaje en pantalla y esperar la confirmación del jugador

func show_action_menu():
	pass
	# Mostrar el menú de acciones para que el jugador elija su próximo movimiento
