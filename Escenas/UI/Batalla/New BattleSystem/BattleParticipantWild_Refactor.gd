extends BattleParticipant_Refactor
class_name BattleParticipantWild_Refactor

func _init():
	is_trainer = false
	ai_controller = BattleIA_Wild.new()
	sprite_path = ""  # O alguna imagen genérica de Pokémon salvaje
