extends BattleParticipant_Refactor
class_name BattleParticipantWild_Refactor

func _init(_pokemon_team: Array[BattlePokemon_Refactor] = []):
	self.is_trainer = false
	self.ai_controller = BattleIA_Wild_Refactor.new()
	self.sprite_path = ""  # O alguna imagen genérica de Pokémon salvaje
	self.add_pokemon_team(_pokemon_team)
