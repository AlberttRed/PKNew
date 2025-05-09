extends Node2D
class_name BattleSpot_Refactor

var pokemon: BattlePokemon_Refactor = null

@onready var sprite: Sprite2D = $Sprite
@onready var shadow: Sprite2D = $Shadow

@onready var hp_bar: HPBar_Refactor = $HPBar
@onready var hp_bar_pos_single: Marker2D = $Positions/HPBarPos_Single
@onready var hp_bar_pos_double: Marker2D = $Positions/HPBarPos_Double

func set_pokemon(p: BattlePokemon_Refactor) -> void:
	pokemon = p
	if pokemon.side.type == BattleSide_Refactor.Types.PLAYER:
		sprite.texture = pokemon.get_back_sprite()
	else:
		sprite.texture = pokemon.get_front_sprite()
	show()
	
func load_active_pokemon(pokemon: BattlePokemon_Refactor, rules: BattleRules) -> void:
	pokemon = pokemon
	pokemon.set_battle_spot(self)
	pokemon.in_battle = true

	# Asignar sprite
	if pokemon.side.type == BattleSide_Refactor.Types.PLAYER:
		sprite.texture = pokemon.get_back_sprite()
	else:
		sprite.texture = pokemon.get_front_sprite()

	# Posicionar sprite si hiciera falta (ya tenías set_sprite_position)
	#set_sprite_position()

	# Mostrar sombra si es salvaje
	shadow.visible = pokemon.is_wild

	# Mostrar sprite
	sprite.visible = true

	# Inicializar y posicionar HPBar
	hp_bar.init(pokemon)
	hp_bar.setup_for(pokemon.side.type, rules.mode)
	position_hp_bar(rules.mode)
	hp_bar.visible = true

	# Mostrar el spot completo
	self.visible = true

func clear() -> void:
	sprite.texture = null
	hide()

func position_hp_bar(mode: int) -> void:
	match mode:
		BattleRules.BattleModes.SINGLE:
			hp_bar.global_position = hp_bar_pos_single.global_position
		BattleRules.BattleModes.DOUBLE:
			hp_bar.global_position = hp_bar_pos_double.global_position
		_:
			push_warning("Modo de batalla no soportado para posicionar HPBar")


func play_enter_animation():
	# Simple animación de entrada, si querés algo visual
	# Podés conectarlo luego con AnimationPlayer o con tween
	pass
