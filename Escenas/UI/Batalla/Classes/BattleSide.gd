extends Node2D
class_name BattleSide
	
@export var type : CONST.BATTLE_SIDES = CONST.BATTLE_SIDES.NONE
@export var opponentSide : BattleSide

@onready var pokemonSpotA:BattlePokemon = $PokemonA
@onready var pokemonSpotB:BattlePokemon = $PokemonB

var participants : Array[BattleParticipant] # Numero d' "Entrenadors" del Side
var pokemonParty : Array[PokemonInstance] # La party que tindrà el side en el combat, formada per pokemons del/s BattleParticipant/s
	#get:
		#var pokemonList: Array[PokemonInstance]
		#pokemonList.assign($Party.get_children())
		#return pokemonList
var activePokemons : Array[BattlePokemon] # Indica els pokemons que estan actius en el combat lluitant per aquell side
var activeFieldEffectsFlags : Array[CONST.MOVE_EFFECTS] = []

var defeated : bool = false # Indica si tots els pokemons del Side han estat derrotats, per tant el Side ha perdut
var escapeAttempts:int #Player attemps to exit the battle. If a Move is selected, the attemps counter will restart

#func _init(_type : CONST.BATTLE_SIDES):
	#type = _type
	#
func addParticipant(_participant : Battler, _controllable : bool):
	print("ia " + str(_participant.battleIA))
	var p : BattleParticipant = BattleParticipant.new(_participant, _controllable)
	p.side = self
	participants.push_back(p)
	

func initSide(rules: BattleRules):
	assert(!participants.is_empty(), "No s'ha carregat cap Participant per el side")
	escapeAttempts = 0
	loadParty()
	if participants.size() == 1:
		pokemonSpotA.setParticipant(participants[0])
		pokemonSpotA.show()
		if rules.mode == CONST.BATTLE_MODES.DOUBLE:
			pokemonSpotB.setParticipant(participants[0])
			pokemonSpotB.hide()
		else:
			pokemonSpotB.hide()
	elif participants.size() == 1:
		pokemonSpotA.setParticipant(participants[0])
		pokemonSpotA.show()
		pokemonSpotB.setParticipant(participants[1])
		pokemonSpotB.show()
	activePokemons = loadActivePokemons()
		
func hasWorkingFieldEffect(e):
	return activeFieldEffectsFlags.has(e)

# Funció que munta el party del Side, segons el número d'entrenadors del side. Si es un entrenador, agafarà els 6 pk
# d'aquell entrenador. Si hi ha 2 entrenadors, agafarà 3 d'un i 3 de l'altre (com a màxim)
func loadParty():
	var num_part = participants.size()
	var num_pk : int = 6.0 / num_part
	
	var i : int = 0
	
	for part in participants:
		for pk:PokemonInstance in part.pokemonTeam:
			if i != num_pk && !pk.fainted:
				pk.inBattleParty = true
				#$Party.add_child(pk)
				pokemonParty.push_back(pk)
				i += 1
		i = 0

func getNextPartyPokemon():
	for p:PokemonInstance in pokemonParty:
		if !p.fainted:
			return p
	return null
	

func loadActivePokemons():
	var list:Array[BattlePokemon]
	for n in get_children():
		if n is BattlePokemon and n.visible:
			print(name + ": " +n.name)
			list.push_back(n)
	return list
			

func isDefeated():
	print("party ")

	for p in pokemonParty:
		print(p.Name + " " + str(p.hp_actual))
		if !p.fainted:
			return false
	return true
	
func restartEscapeAttempts():
	escapeAttempts = 0

func clear():
	participants.clear()
	pokemonParty.clear()
	activePokemons.clear()

	
