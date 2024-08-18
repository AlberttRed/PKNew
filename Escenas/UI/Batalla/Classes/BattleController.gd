class_name BattleController
	
var rules : BattleRules = null
var playerSide: BattleSide:
	get:
		return UI.playerSide
var enemySide: BattleSide:
	get:
		return UI.enemySide
var sides : Array[BattleSide] = []
var stage : CONST.BATTLE_STAGES

var activePokemons : Array[BattlePokemon]: # Indica els pokemons que estan actius en el combat lluitant
	get:
		return playerSide.activePokemons + enemySide.activePokemons
	
var active_pokemon : BattlePokemon # Indica el pokémon actiu que està fent el turn

var turnPokemonOrder : Array[BattlePokemon]
var activeWeather : CONST.WEATHER = CONST.WEATHER.NONE #Només pot haver-hi un tipus de Weather actiu a la vegada


var UI : BattleUI:
	get:
		return GUI.battle
	
func _init(_battleRules : BattleRules):
	rules = _battleRules

func initBattle():

	assert(playerSide != null or enemySide != null, "No se han configurado los BattleSide para el combate.")
	setSides()

	await GUI.initBattleTransition()
	UI = GUI.battle.initUI(self)
	#Temporalment ho fem aixi, quan fem les animacions d'entrada etc es canviarà
	initActivePokemons()
	await GUI.battle.playAnimation("START_BATTLE_GRASS")
	#await GUI.battle.playAnimation("RESET")
	stage = CONST.BATTLE_STAGES.SELECT_ACTION
	print("enemy size: " + str(enemySide.activePokemons.size()))
	
	if rules.type == CONST.BATTLE_TYPES.WILD:
		await startWildBattle()
	elif rules.type == CONST.BATTLE_TYPES.TRAINER:
		await startTrainerBattle()
	
	#await showActivePokemons()
	
	#await UI.msgBox.finished
	#await UI.msgClosed
	
	await takeTurn()

func takeTurn():
	if stage == CONST.BATTLE_STAGES.SELECT_ACTION:
		print("active pokemons :" + str(activePokemons))
		for p in activePokemons:
			p.initTurn()
			active_pokemon = p
			active_pokemon.selectAction()
			if p.controllable:
				GUI.battle.playAnimation("SELECT_ACTION",{}, p.battleSpot)
				await active_pokemon.actionSelected
				GUI.battle.stopAnimation("SELECT_ACTION")
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
						e.battleSpot.removeActivePokemon()
			
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
		for p:BattleSpot in s.battleSpots:
			p.loadActivePokemon(p.side.getNextPartyPokemon())
			
	print_active_pokemons()
	
func showActivePokemons():
	#for s:BattleSide in sides:
		#if s.isWild:
			#for p:BattleSpot in s.battleSpots:
				#await GUI.battle.showHPBarUI(p.HPbar)
		#else:
			#await enemySide.showActivePokemons()
	#await SignalManager.ANIMATION.finished_animation
	#for s:BattleSide in sides:
		#if !s.isWild:
			#for p:BattleSpot in s.battleSpots:
				#await GUI.battle.showHPBarUI(p.HPbar)
	await enemySide.showActivePokemons()
	await playerSide.showActivePokemons()
			
func print_active_pokemons():
	for p in activePokemons:
		p.print_pokemon()
		print(" ")
		p.print_moves()

func updateActivePokemonsInfo():
	for pokemon:BattlePokemon in activePokemons:	
		for enemy:BattlePokemon in pokemon.listEnemies:
			if pokemon != null and enemy != null:
				if !pokemon.listPokemonBattledAgainst.has(enemy):
					pokemon.listPokemonBattledAgainst.push_back(enemy)

func updateActivePokemons():
	##var enemies:Array[BattlePokemon] = sides[1].activePokemons#.duplicate()
	##var allies:Array[BattlePokemon] =  sides[0].activePokemons#.duplicate()
	##
	##activePokemons = playerSide.activePokemons + enemySide.activePokemons
	#print("active pokemons: " + str(activePokemons.size()))
		#
	for p:BattlePokemon in activePokemons:
		p.updateBattleInfo()
		#p.clear()
#
		##if p.side.type == CONST.BATTLE_SIDES.PLAYER:
		#p.setEnemies(p.side.opponentSide.activePokemons)
		#p.setAllies(p.side.activePokemons)
		#
		##elif p.side.type == CONST.BATTLE_SIDES.ENEMY:
			##print("lololo")
			##p.setEnemies(allies)
			##p.setAllies(enemies)
			#
	#for p in activePokemons:
		#for e in p.listEnemies:
			#if !p.listPokemonBattledAgainst.has(e):
				#p.listPokemonBattledAgainst.push_back(e)

func setSides():
	self.sides = [playerSide, enemySide]
	self.playerSide.opponentSide = enemySide
	self.enemySide.opponentSide = playerSide
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
	
func startWildBattle():
	for p:BattleSpot in enemySide.battleSpots:
		await p.showHPBar()
	if enemySide.activePokemons.size() == 1:
		await GUI.battle.showMessage("¡Un " + enemySide.activePokemons[0].Name + " salvaje te corta el paso!", false, 1.5)
		#await UI.showMessageInput("¡Un " + enemySide.activePokemons[0].Name + " salvaje te corta el paso!")
	
	await playerSide.showActivePokemons()
	
func startTrainerBattle():
	pass
	
	#await enemySide.showActivePokemons()
	#await playerSide.showActivePokemons()

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

#func doCommonAnimation(root:Object, animName:String):
	#if FileAccess.file_exists("res://Animaciones/Batalla/General/Classes/" + str(animName) + ".gd") != null:
		#var animation:BattleCommonAnimation = load("res://Animaciones/Batalla/General/Classes/" + str(animName) + ".gd").new(root.animPlayer, animName)
		#print("lololol")
		##animation.addParameter("battleSpot", active_pokemon.battleSpot)
		#await animation.doAnimation()
		##await load("res://Animaciones/Batalla/General/Classes/"+str(animName)+".gd").new(animName).doAnimation()
