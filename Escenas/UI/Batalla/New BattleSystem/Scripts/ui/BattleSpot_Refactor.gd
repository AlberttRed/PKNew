extends Node2D
class_name BattleSpot_Refactor

var pokemon: BattlePokemon_Refactor = null
var side: BattleSide_Refactor
var tween: Tween

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
	
func load_active_pokemon(_pokemon: BattlePokemon_Refactor, rules: BattleRules) -> void:
	self.pokemon = _pokemon
	self.pokemon.set_battle_spot(self)
	self.pokemon.in_battle = true

	# Asignar sprite
	if self.pokemon.side.type == BattleSide_Refactor.Types.PLAYER:
		sprite.texture = self.pokemon.get_back_sprite()
	else:
		sprite.texture = self.pokemon.get_front_sprite()

	# Posicionar sprite si hiciera falta (ya tenías set_sprite_position)
	#set_sprite_position()

	# Mostrar sombra si es salvaje
	shadow.visible = self.pokemon.is_wild

	# Mostrar sprite
	sprite.visible = true

	# Inicializar y posicionar HPBar
	hp_bar.init(self.pokemon)
	hp_bar.setup_for(self.pokemon.side.type, rules.mode)
	position_hp_bar(rules.mode)
	hp_bar.visible = true

	# Mostrar el spot completo
	self.visible = true
	if _pokemon.ability and _pokemon.ability.effect_resource:
		var effect = pokemon.ability.effect_resource.duplicate()
		effect.source = pokemon
		BattleEffectController.register_effect(effect, pokemon)


func get_active_pokemon() -> BattlePokemon_Refactor:
	return pokemon
	
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

func highlight(active: bool) -> void:
	if tween:
		tween.kill()
		tween = null

	if active:
		tween = create_tween()
		tween.set_loops()
		tween.tween_property($Sprite, "modulate:a", 0.3, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property($Sprite, "modulate:a", 1.0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		$Sprite.modulate.a = 1.0

func get_opponent_side() -> BattleSide_Refactor:
	return side.opponent_side
	
func has_active_pokemon() -> bool:
	return pokemon != null and not pokemon.is_fainted()

func apply_damage(damage: MoveImpactResult.Damage) -> void:
	if get_active_pokemon() == null:
		return

	get_active_pokemon().take_damage(damage)
	
	if hp_bar:
		await hp_bar.update_hp(get_active_pokemon().hp)

func play_hit_animation() -> void:
	if not is_visible():
		return

	var tween := create_tween()
	tween.set_parallel(false) # animación secuencial (no solapada)

	# Parpadeo: transparente → visible (2 veces)
	for i in 2:
		tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0.0), 0.1)
		tween.tween_property(sprite, "modulate", Color(1, 1, 1, 1.0), 0.1)

	await tween.finished
	await get_tree().create_timer(0.5).timeout

func play_enter_animation():
	# Simple animación de entrada, si querés algo visual
	# Podés conectarlo luego con AnimationPlayer o con tween
	pass
