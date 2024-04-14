class_name BattleParticipant

var pokemonTeam : Array[BattlePokemon] # El número de pokémons que tindrà el battler, i que per tant controlarà
var controllable : bool # Indica si el participant el controlarà el Jugador o la IA
var side : BattleSide

func _init(_participant : Battler, _controllable : bool):
	controllable = _controllable
	print(_participant.battleIA)
	for p in _participant.party:
		var bp:BattlePokemon = load("res://Objetos/Batalla/Nodes/BattlePokemonNode.tscn").instantiate()
		bp.create(p, _participant.battleIA)
		#var bp = BattlePokemon.new(p, _participant.battleIA)
		bp.isWild = _participant.type == CONST.BATTLER_TYPES.WILD_POKEMON
		bp.controllable = _controllable
		bp.participant = self
		bp.visible = false
		pokemonTeam.push_back(bp)

#Check if at least one pokemon has the Exp. All item equipped
func hasExpAllEquiped():
	if getExpAllEquipedCount() > 0:
		return true
	else:
		return false

#How many pokmeon in the party have Exp. All item equipped
func getExpAllEquipedCount():
	var count:int = 0
	for p:BattlePokemon in pokemonTeam:
		if p.instance.hasItemEquipped(12):
			count += 1
	return count

#How many pokmeon in the party have Exp. All item equipped
func getPKMNwithExpAll():
	var pkmns:Array[BattlePokemon] = []
	for p:BattlePokemon in pokemonTeam:
		if p.instance.hasItemEquipped(12):
			pkmns.push_back(p)
	return pkmns

func swapPokemon(enterPokemon:BattlePokemon, exitPokemon:BattlePokemon):
	GUI.battle.removeActivePokemon(exitPokemon)
	GUI.battle.loadActivePokemon(enterPokemon)
	#el BattlePokemon tindra una funció de seapOut o swapIN, que farà l'animació d'entrada/sortida
	print("SWAPPING BRO")

func bringInPokemon(pokemon:BattlePokemon):
	pokemon.enterBattle()
	
func bringOutOutPokemon(pokemon:BattlePokemon):
	pokemon.quitBattle()

func queue_free():
	if pokemonTeam != null:
		pokemonTeam.clear()
	free()
