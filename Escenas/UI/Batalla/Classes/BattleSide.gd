class_name BattleSide
	
var type : CONST.BATTLE_SIDES = CONST.BATTLE_SIDES.NONE

var opponentSide : BattleSide
var participants : Array[BattleParticipant] # Numero d' "Entrenadors" del Side
var pokemonParty : Array[BattlePokemon] # La party que tindrà el side en el combat, formada per pokemons del/s BattleParticipant/s
var activePokemons : Array[BattlePokemon] # Indica els pokemons que estan actius en el combat lluitant per aquell side

var activeFieldEffectsFlags : Array[CONST.MOVE_EFFECTS] = []

var defeated : bool = false # Indica si tots els pokemons del Side han estat derrotats, per tant el Side ha perdut
var escapeAttempts:int #Player attemps to exit the battle. If a Move is selected, the attemps counter will restart

func _init(_type : CONST.BATTLE_SIDES):
	type = _type
	
func addParticipant(_participant : Battler, _controllable : bool):
	print("ia " + str(_participant.battleIA))
	var p : BattleParticipant = BattleParticipant.new(_participant, _controllable)
	p.side = self
	participants.push_back(p)
	

func initSide():
	
	assert(!participants.is_empty(), "No s'ha carregat cap Participant per el side")
	escapeAttempts = 0
	loadParty()
	
	return self
	
func hasWorkingFieldEffect(e):
	return activeFieldEffectsFlags.has(e)

# Funció que munta el party del Side, segons el número d'entrenadors del side. Si es un entrenador, agafarà els 6 pk
# d'aquell entrenador. Si hi ha 2 entrenadors, agafarà 3 d'un i 3 de l'altre (com a màxim)
func loadParty():
	var num_part = participants.size()
	var num_pk : int = 6.0 / num_part
	
	var i : int = 0
	
	for part in participants:
		for pk in part.pokemonTeam:
			if i != num_pk:
				pk.inBattleParty = true
				pokemonParty.push_back(pk)
				i += 1
		i = 0

func isDefeated():
	print("party ")

	for p in pokemonParty:
		print(p.Name + " " + str(p.hp_actual))
		if !p.fainted:
			return false
	return true
	
func restartEscapeAttempts():
	escapeAttempts = 0

func queue_free():
	if participants != null:
		for p in participants:
			p.queue_free()
	participants.clear()
	
	if pokemonParty != null:
		for p in pokemonParty:
			p.queue_free()
	pokemonParty.clear()
	
	if activePokemons != null:
		for p in activePokemons:
			p.queue_free()
	activePokemons.clear()
	free()
	
