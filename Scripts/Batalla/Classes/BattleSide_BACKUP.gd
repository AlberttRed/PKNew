#extends Node2D
	#
#@export var type : CONST.BATTLE_SIDES = CONST.BATTLE_SIDES.NONE
#@export var opponentSide : BattleSide
#@export var isWild : bool = false
#
#@onready var pokemonSpotA:BattleSpot = $PokemonA
#@onready var pokemonSpotB:BattleSpot = $PokemonB
#
#@onready var trainerA:BattleParticipant = $TrainerA
#@onready var trainerB:BattleParticipant = $TrainerB
#
#var participants : Array[BattleParticipant] # Numero d' "Entrenadors" del Side
#var pokemonParty : Array[BattlePokemon] # La party que tindrà el side en el combat, formada per pokemons del/s BattleParticipant/s
	##get:
		##var pokemonList: Array[PokemonInstance]
		##pokemonList.assign($Party.get_children())
		##return pokemonList
#var battleSpots:Array[BattleSpot]:
	#get:
		#return getBattleSpots()
#var activePokemons : Array[BattlePokemon]: # Indica els pokemons que estan actius en el combat lluitant per aquell side
	#get:
		#return getActivePokemons()
#var defeated : bool = false # Indica si tots els pokemons del Side han estat derrotats, per tant el Side ha perdut
#var escapeAttempts:int #Player attemps to exit the battle. If a Move is selected, the attemps counter will restart
#var field : BattleField
#var controllable:
	#get:
		#for p:BattleParticipant in participants:
			#if p.controllable:
				#return true
		#return false
##func _init(_type : CONST.BATTLE_SIDES):
	##type = _type
	##
#func addParticipant(_participant : Battler, _controllable : bool):
	#print("ia " + str(_participant.battleIA))
	#var participant:BattleParticipant
	#if participants.is_empty():
		#participant = trainerA
	#else:
		#participant = trainerB
	#participant.setParticipant(_participant, _controllable)
	###var p : BattleParticipant = BattleParticipant.new(_participant, _controllable)
	#participant.side = self
	#participants.push_back(participant)
	#
#
#func initSide(rules: BattleRules):
	#assert(!participants.is_empty(), "No s'ha carregat cap Participant per el side")
	#escapeAttempts = 0
	#field = BattleField.new()
	#loadParty()
	#if participants.size() == 1:
		#pokemonSpotA.setParticipant(participants[0])
		#pokemonSpotA.setSide(self)
		#pokemonSpotA.HPbar = $HPBarA
		#pokemonSpotA.show()
		#if rules.mode == CONST.BATTLE_MODES.DOUBLE:
			#pokemonSpotB.setParticipant(participants[0])
			#pokemonSpotB.setSide(self)
			#pokemonSpotB.HPbar = $HPBarB
			#pokemonSpotB.show()
		#else:
			#pokemonSpotB.hide()
	#elif participants.size() == 2:
		#pokemonSpotA.setParticipant(participants[0])
		#pokemonSpotA.setSide(self)
		#pokemonSpotA.HPbar = $HPBarA
		#pokemonSpotA.show()
		#pokemonSpotB.setParticipant(participants[1])
		#pokemonSpotB.setSide(self)
		#pokemonSpotB.HPbar = $HPBarB
		#pokemonSpotB.show()
	##activePokemons = getActivePokemons()
		#
##func hasWorkingFieldEffect(e:BattleEffect.List):
	##var name:String = str(BattleEffect.List.keys()[e])
	##
	##for effect:BattleEffect in field.activeBattleEffects:
		##var n = effect.name
		##if(n == name):
			##return true
	##return false
#
#func hasWorkingEffect(effectName:String) -> bool:
	#for battleEffect:BattleEffect in field.activeBattleEffects:
		#if effectName == battleEffect.name:
			#return true
	#return false
	#
#func hasAilmentEffect(ailmentCode:BattleEffect.Ailments) -> bool:
	#return hasWorkingEffect(BattleEffect.Ailments.keys()[ailmentCode])
	#
#func hasMoveEffect(moveCode:BattleEffect.Moves) -> bool:
	#return hasWorkingEffect(BattleEffect.Moves.keys()[moveCode])
	#
#func addBattleEffect(effect : BattleEffect):
	#if effect == null:
		#return
	#SignalManager.Battle.Effects.add.emit(effect, field)
#
#func removeBattleEffect(effect : BattleEffect):
	#if effect == null:
		#return
	#SignalManager.Battle.Effects.remove.emit(effect, field)
	#
## Funció que munta el party del Side, segons el número d'entrenadors del side. Si es un entrenador, agafarà els 6 pk
## d'aquell entrenador. Si hi ha 2 entrenadors, agafarà 3 d'un i 3 de l'altre (com a màxim)
#func loadParty():
	#var num_part = participants.size()
	#var num_pk : int = 6.0 / num_part
	#
	#var i : int = 0
	#
	#for part:BattleParticipant in participants:
		#for pk:BattlePokemon in part.pokemonTeam:
			#if i != num_pk && !pk.fainted:
				#pk.inBattleParty = true
				##$Party.add_child(pk)
				#pokemonParty.push_back(pk)
				#i += 1
		#i = 0
#
#func getNextPartyPokemon():
	#for p:BattlePokemon in pokemonParty:
		#if !p.fainted:
			#return p
	#return null
	#
#
#func getActivePokemons():
	#var list:Array[BattlePokemon] = []
	#for s:BattleSpot in battleSpots:
		#if s.activePokemon != null:
			#list.push_back(s.activePokemon)
	##for n in get_children():
		##if n is BattleSpot and n.visible and n.activePokemon != null:
			##print(name + ": " +n.name)
			##list.push_back(n.activePokemon)
	#return list
	#
#func getBattleSpots():
	#var list:Array[BattleSpot] = []
	#for p:BattleParticipant in participants:
		#list.append_array(p.battleSpots)
	#return list
#
#func isDefeated():
	#print("party ")
#
	#for p in pokemonParty:
		#print(p.Name + " " + str(p.hp_actual))
		#if !p.fainted:
			#return false
	#return true
	#
#func restartEscapeAttempts():
	#escapeAttempts = 0
#
#func clear():
	#for p:BattleParticipant in participants:
		#p.clear()
	#participants.clear()
	#pokemonParty.clear()
	#activePokemons.clear()
	#field.activeBattleEffects.clear()
	#field = null
#
	#
#
#func showActivePokemons():
	#if !isWild:
		#for p:BattleParticipant in participants:
			#p.bringStarterPokemons()
		#await SignalManager.Animations.finished_animation
		##for p:BattleSpot in battleSpots:
			##await p.showHPBar()
	#
#func getActiveBattleEffects(_pokemon:BattlePokemon):
	#var effectList : Array[BattleEffect]
	#if field == null:
		#return null
	#for e:BattleEffect in field.activeBattleEffects:
		#e.setTarget(_pokemon)
		#effectList.push_back(e)
	#return effectList
	#
#func playAnimation(animation:String, animParams:Dictionary = {}):
	#SignalManager.Battle.Animations.playAnimation.emit(animation, animParams, self)
	#await SignalManager.Animations.finished_animation
