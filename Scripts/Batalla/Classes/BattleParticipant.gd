extends Node2D
class_name BattleParticipant

var pokemonTeam : Array[BattlePokemon] # El número de pokémons que tindrà el battler, i que per tant controlarà
var controllable : bool # Indica si el participant el controlarà el Jugador o la IA
var battleSpots : Array[BattleSpot] # Indica quins "spots" controla el participant (PokemonA/pokemonB)
@onready var sprite : Sprite2D = $Sprite
var side : BattleSide
var activePokemons : Array[BattlePokemon]: # Indica els pokemons que estan actius en el combat lluitant per aquell side
	get:
		return getActivePokemons()
var pendingPokemonChanges:bool:
	get:
		return !getPendingPokemonChanges().is_empty()
		
var hasAvailablePokemon:bool:
	get:
		return !getAvailablePokemon().is_empty()
#var IA: BattleIA

# Given a Battler, load the Participant Party from battler's party. Also assigns an IA to the particpant
func setParticipant(_participant : Battler, _controllable : bool):
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
func getPKMNwithExpAll() -> Array[BattlePokemon]:
	var pkmns:Array[BattlePokemon] = []
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

func bringStarterPokemons():
	if side.type == CONST.BATTLE_SIDES.PLAYER:
		await playAnimation("PLAYER_TRAINER")
	else:
		if !side.isWild:
			await playAnimation("ENEMY_TRAINER")
		
func showActivePokemons():
	for b:BattleSpot in battleSpots:
		b.enterPokemon(b.activePokemon)

func playAnimation(animation:String, animParams:Dictionary = {}):
	SignalManager.Battle.Animations.playAnimation.emit(animation, animParams, self)
	await SignalManager.Animations.finished_animation
	#await GUI.battle.playAnimation(animation, animParams, self)

func getNextPokemons() -> Array[BattlePokemon]:
	return battleSpots.map(func(bs:BattleSpot): return bs.nextPokemon).filter(func(pk:BattlePokemon): return pk!=null)

func getPendingPokemonChanges():
	return  battleSpots.filter(func(bs): return bs.pendingPokemonChanges)


func getAvailablePokemon():
	return pokemonTeam.filter(func(pk:BattlePokemon): return !pk.inBattle and !pk.fainted)


func getActivePokemons():
	var list:Array[BattlePokemon] = []
	for s:BattleSpot in battleSpots:
		if s.activePokemon != null:
			list.push_back(s.activePokemon)
	#for n in get_children():
		#if n is BattleSpot and n.visible and n.activePokemon != null:
			#print(name + ": " +n.name)
			#list.push_back(n.activePokemon)
	return list
	
func selectNextPokemons():
	for bs:BattleSpot in battleSpots:
		await bs.selectNextPokemon()

func clear():
	if pokemonTeam != null:
		pokemonTeam.clear()
