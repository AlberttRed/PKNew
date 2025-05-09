extends Node

class_name BattleController_Refactor

signal battle_started
signal battle_ended

var ui: BattleUI_Refactor
#var animation_controller: BattleAnimationControllerRefactor
#var effect_manager: BattleEffectPhaseManagerRefactor

var rules: BattleRules
var participants: Array = []
var player_side: BattleSide_Refactor
var enemy_side: BattleSide_Refactor
var sides: Array[BattleSide_Refactor]

var finished := false

func _ready():
	# Este método puede quedar vacío si se usa start_battle() desde BattleScene
	pass

# Configura los dos BattleSide con sus participantes y reglas
func setup_sides(player_participants: Array[BattleParticipant_Refactor], enemy_participants: Array[BattleParticipant_Refactor], rules: BattleRules):

	var player_side = BattleSide_Refactor.new(BattleSide_Refactor.Types.PLAYER)
	for p in player_participants:
		player_side.add_participant(p)
	player_side.prepare_for_battle(rules)
	
	var enemy_side = BattleSide_Refactor.new(BattleSide_Refactor.Types.ENEMY)
	for p in enemy_participants:
		enemy_side.add_participant(p)
	enemy_side.prepare_for_battle(rules)
	
	self.player_side = player_side
	self.enemy_side = enemy_side
	self.sides = [player_side, enemy_side]

	self.rules = rules

func start_battle() -> void:
	ui.visible = true  # Si estaba oculto por defecto
	print("Combate iniciado (test)")
#
#func init_battle():
	## Configura elementos iniciales, como UI, animaciones de entrada, etc.
	#effect_manager.update_active_pokemon_effects(get_active_pokemon())
	#ui.setup_participants(participants)
	## Mostrar sprites, barras, etc.
	## Opcional: mostrar pokéballs, habilidades, clima...
#
#func loop_turns():
	#while not finished:
		#await effect_manager.apply_turn_start()
#
		#var turn := BattleTurn.new(get_active_pokemon())
		#await turn.collect_choices()
		#await turn.execute()
#
		#await effect_manager.apply_turn_end()
		#await check_victory_conditions()
#
#func get_active_pokemon() -> Array:
	#var actives = []
	#for participant in participants:
		#actives += participant.get_active_pokemons()
	#return actives
#
#func check_victory_conditions():
	## Implementa la lógica para finalizar el combate
	## Si un equipo no tiene más pokémon, marca la batalla como finalizada
	#if false:  # reemplaza con condición real
		#finished = true
