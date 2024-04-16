class_name BattleParticipant

var pokemonTeam : Array[BattlePokemon] # El número de pokémons que tindrà el battler, i que per tant controlarà
var controllable : bool # Indica si el participant el controlarà el Jugador o la IA
var battleSpots : Array[BattleSpot] # Indica quins "spots" controla el participant (PokemonA/pokemonB)
var side : BattleSide
#var IA: BattleIA

# Given a Battler, load the Participant Party from battler's party. Also assigns an IA to the particpant
func _init(_participant : Battler, _controllable : bool):
	controllable = _controllable
	#self.IA = _participant.battleIA
	print(_participant.battleIA)
	for p:PokemonInstance in _participant.party:
		var battlePokemon:BattlePokemon = BattlePokemon.new(p, _participant.battleIA)
		#var bp:BattlePokemon = load("res://Objetos/Batalla/Nodes/BattlePokemonNode.tscn").instantiate()
		#bp.create(p, _participant.battleIA)
		battlePokemon.isWild = _participant.type == CONST.BATTLER_TYPES.WILD_POKEMON
		battlePokemon.controllable = _controllable
		battlePokemon.participant = self
		#bp.visible = false
		pokemonTeam.push_back(battlePokemon)


#Check if at least one pokemon has the Exp. All item equipped
func hasExpAllEquiped():
	if getExpAllEquipedCount() > 0:
		return true
	else:
		return false

#How many pokmeon in the party have Exp. All item equipped
func getExpAllEquipedCount() -> int:
	var count:int = 0
	for p:BattlePokemon in pokemonTeam:
		if p.hasItemEquipped(12):
			count += 1
	return count

#How many pokmeon in the party have Exp. All item equipped
func getPKMNwithExpAll() -> Array[PokemonInstance]:
	var pkmns:Array[PokemonInstance] = []
	for p:BattlePokemon in pokemonTeam:
		if p.hasItemEquipped(12):
			pkmns.push_back(p)
	return pkmns

func assignBattleSpot(battleSpot:BattleSpot):
	if !self.battleSpots.has(battleSpot):
		self.battleSpots.push_back(battleSpot)

#func swapPokemon(enterPokemon:PokemonInstance, exitPokemon:PokemonInstance):
	#GUI.battle.removeActivePokemon(exitPokemon)
	#GUI.battle.loadActivePokemon(enterPokemon)
	##el BattlePokemon tindra una funció de seapOut o swapIN, que farà l'animació d'entrada/sortida
	#print("SWAPPING BRO")
#
#func bringInPokemon(pokemon:PokemonInstance, battleSpot:BattlePokemon):
	#battleSpot.enterPokemon()
	#
#func bringOutOutPokemon(pokemon:PokemonInstance, battleSpot:BattlePokemon):
	#battleSpot.quitPokemon()

func queue_free():
	if pokemonTeam != null:
		pokemonTeam.clear()
	free()
