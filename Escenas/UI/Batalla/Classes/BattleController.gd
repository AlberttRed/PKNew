class_name BattleController
	
var rules : BattleRules = null
var playerSide : BattleSide = null
var enemySide : BattleSide = null

var sides : Array[BattleSide] = []
var stage : CONST.BATTLE_STAGES

var activePokemons : Array[BattlePokemon] # Indica els pokemons que estan actius en el combat lluitant

var active_pokemon : BattlePokemon # Indica el pokémon actiu que està fent el turn

var turnPokemonOrder : Array[BattlePokemon]
var activeWeather : CONST.WEATHER = CONST.WEATHER.NONE #Només pot haver-hi un tipus de Weather actiu a la vegada


var UI : BattleUI = null
	
func _init(_battleRules : BattleRules):
	rules = _battleRules

func initBattle():

	assert(playerSide != null or enemySide != null, "No se han configurado los BattleSide para el combate.")
	sides = [playerSide, enemySide]
	playerSide.opponentSide = enemySide
	enemySide.opponentSide = playerSide

	
	await GUI.initBattleTransition()
	initActivePokemons()
	UI = GUI.battle.initUI(self)
	
	stage = CONST.BATTLE_STAGES.SELECT_ACTION
	
	await UI.showMessageInput("¡Un " + activePokemons[1].Name + " salvaje te corta el paso!")
	#await UI.msgBox.finished
	#await UI.msgClosed
	
	await takeTurn()

func takeTurn():
	if stage == CONST.BATTLE_STAGES.SELECT_ACTION:
		for p in activePokemons:
			p.initTurn()
			active_pokemon = p
			active_pokemon.selectAction()
			if p.controllable:
				await active_pokemon.actionSelected
			print(p.Name + " selected " + CONST.BATTLE_ACTIONS.keys()[p.selected_action.type])
			
		stage = CONST.BATTLE_STAGES.DO_ACTION
		
	if stage == CONST.BATTLE_STAGES.DO_ACTION:
		orderPokemonByActionPriority()
		
		for p in turnPokemonOrder:
			if !p.fainted:
				p.doAction()
				await p.actionFinished
			#Only give exp if pokemon is from player
			if p.controllable:
				for e in p.listEnemies:
					if e.fainted:
						await e.giveExpAtDefeat()
			
	#endTurn()
	#takeTurn()
	if !battleFinished():
		stage = CONST.BATTLE_STAGES.SELECT_ACTION
		endTurn()
		takeTurn()
	else:
		print("c'est fini")
		await endBattle()
	
func initActivePokemons():
	var pk_per_side : int = 0
	var pk_per_part : int = 0
	if rules.mode == CONST.BATTLE_MODES.SINGLE:
		pk_per_side = 1
	elif rules.mode == CONST.BATTLE_MODES.SINGLE:
		pk_per_side = 2
	
	for s in sides:
		pk_per_part = pk_per_side / s.participants.size()
		for part in s.participants:
			var i : int = 0
			for p in s.pokemonParty:
				#print(p.Name + " fainted? " + str(p.fainted))
				if !p.fainted and p.inBattleParty and i != pk_per_part:
					s.activePokemons.push_back(p)
					i += 1
				else:
					break
					
	updateActivePokemons()
	print_active_pokemons()
			
func print_active_pokemons():
	for p in activePokemons:
		p.print_pokemon()
		print(" ")
		p.print_moves()
		
func updateActivePokemons():
	var enemies:Array[BattlePokemon] = sides[1].activePokemons#.duplicate()
	var allies:Array[BattlePokemon] =  sides[0].activePokemons#.duplicate()
	
	activePokemons = allies + enemies
		
	for p in activePokemons:
		if p.side.type == CONST.BATTLE_SIDES.PLAYER:
			p.setEnemies(enemies)
			p.setAllies(allies)
		elif p.side.type == CONST.BATTLE_SIDES.ENEMY:
			print("lololo")
			p.setEnemies(allies)
			p.setAllies(enemies)
			
	for p in activePokemons:
		for e in p.listEnemies:
			if !p.listPokemonBattledAgainst.has(e):
				p.listPokemonBattledAgainst.push_back(e)

#		print("player side: ")
#		for a in allies:
#			print(a.Name)
#		print("enemies side: ")
#		for e in enemies:
#			print(e.Name)	
#
#		print(p.Name)
#		print("allies")
#		for a in p.allies:
#			print(a.Name)
#
#		print("enemies")
#		for a in p.enemies:
#			print(a.Name)
			
func orderPokemonByActionPriority():
	turnPokemonOrder = activePokemons
#	for p in activePokemons:
#		turnPokemonOrder.push_back(p)
	
	turnPokemonOrder.sort_custom(sortChoices)
	

#Funció que ordena els actions de cada pokemon actiu segons prioritat, per saber en quin ordre s'executarà cada atac/acció
func sortChoices(a : BattlePokemon, b : BattlePokemon):
	var choice_a = a.selected_action
	var choice_b = b.selected_action
	
	var unix_time: float = Time.get_unix_time_from_system()
	var unix_time_int: int = unix_time
	var dt: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	
	if choice_a.priority > choice_b.priority:
		return true
	elif choice_a.priority < choice_b.priority:
		return false
	else:
		if choice_a is BattleMoveChoice and choice_b is BattleMoveChoice:
			if a.getModStat(CONST.STATS.VEL) > b.getModStat(CONST.STATS.VEL):
				return true
			elif a.getModStat(CONST.STATS.VEL) < b.getModStat(CONST.STATS.VEL):
				return false
			else:
				#En aquest cas, hauria de seleccionar un dels dos aleatoriament, pero pel que vaig llegir no es recomenable.
				#Per fer-ho una mica random, mirem si el minut de l'hora actual es par o impar.
				if dt.minute % 2 == 0:
					return true
				else:
					return false
		else:
			#En aquest cas, hauria de seleccionar un dels dos aleatoriament, pero pel que vaig llegir no es recomenable.
			#Per fer-ho una mica random, mirem si el minut de l'hora actual es par o impar.
			if dt.minute % 2 == 0:
				return true
			else:
				return false
			
func battleFinished():
	print("sides size " + str(sides.size()))
	for s in sides:
		if s.isDefeated():
			return true
	return false
	
func endTurn():
	for p in activePokemons:
		p.endTurn()
	#turnPokemonOrder.clear()
	
func endBattle():
	await GUI.fadeIn(1.3)
	UI.clear()
	await GUI.get_tree().create_timer(1).timeout
	await GUI.fadeOut(3)
	
func queue_free():
	rules = null
	playerSide = null
	enemySide = null

	sides.clear()
		
	activePokemons.clear()
	active_pokemon = null

	turnPokemonOrder.clear()

