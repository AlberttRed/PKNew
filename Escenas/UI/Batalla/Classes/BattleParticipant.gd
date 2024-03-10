class_name BattleParticipant

var pokemonTeam : Array[BattlePokemon] # El número de pokémons que tindrà el battler, i que per tant controlarà
var controllable : bool # Indica si el participant el controlarà el Jugador o la IA
var side : BattleSide

func _init(_participant : Battler, _controllable : bool):
	controllable = _controllable
	print(_participant.battleIA)
	for p in _participant.party:
		var bp = BattlePokemon.new(p, _participant.battleIA)
		bp.controllable = _controllable
		bp.participant = self
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
	
func queue_free():
	if pokemonTeam != null:
		pokemonTeam.clear()
	free()
