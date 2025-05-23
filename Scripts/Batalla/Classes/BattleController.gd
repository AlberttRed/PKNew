class_name BattleController

signal newTurn
	
var rules : BattleRules = null
var playerParticipant: BattleParticipant:
	get:
		return playerSide.participants.filter(func(bp:BattleParticipant): return bp.controllable).front()
var playerSide: BattleSide:
	get:
		return UI.playerField.side
var enemySide: BattleSide:
	get:
		return UI.enemyField.side
var sides : Array[BattleSide] = []
var stage : CONST.BATTLE_STAGES

var activeBattleSpots : Array[BattleSpot]: # Indica els pokemons que estan actius en el combat lluitant
	get:
		return playerSide.battleSpots + enemySide.battleSpots
		
var activePokemons : Array[BattlePokemon]: # Indica els pokemons que estan actius en el combat lluitant
	get:
		return playerSide.activePokemons + enemySide.activePokemons
	
var activeBattleSpot : BattleSpot:
	set(bs):
		activeBattleSpot = bs
		effects.activePokmeon = bs.activePokemon
var active_pokemon : BattlePokemon: # Indica el pokémon actiu que està fent el turn
	get:
		return activeBattleSpot.activePokemon
var turnPokemonOrder : Array[BattleSpot]
var effects : BattleEffectControllerOLD
#var activeWeathereffect : BattleWeatherEffect = null # CONST.WEATHER = CONST.WEATHER.NONE #Només pot haver-hi un tipus de Weather actiu a la vegada
var activeWeather
var field:BattleField:
	get:
		return UI.field

var UI : BattleUI:
	get:
		return GUI.battle
		
var expHandler:BattleExperienceHandler = BattleExperienceHandler.new()
	
func _init(_battleRules : BattleRules):
	rules = _battleRules
	effects = BattleEffectControllerOLD.new(self)
	UI.playerField._init()
	UI.enemyField._init()
	#playerSide = BattleSide.new(UI.playerField)
	#enemySide = BattleSide.new(UI.enemyField)

func initBattle():

	setSides()
	#assert(playerSide == null or enemySide == null, "No se han configurado los BattleSide para el combate.")

	await GUI.initBattleTransition()
	UI.initUI(self)
	if rules.weather != BattleRules.BattleWeather.NONE:
		pass
		#addPersistentWeather(rules.weather)
	#Temporalment ho fem aixi, quan fem les animacions d'entrada etc es canviarà
	initActivePokemons()
	#GUI.battle.get_node("AnimationController").get_animation("Battle_GeneralAnimations/START_BATTLE").set_length(4.1)
	await GUI.battle.playAnimation("START_BATTLE")
	#await GUI.battle.playAnimation("RESET")
	stage = CONST.BATTLE_STAGES.SELECT_ACTION
	print("enemy size: " + str(enemySide.activePokemons.size()))
	
	if rules.type == BattleRules.BattleTypes.WILD:
		await startWildBattle()
	elif rules.type == BattleRules.BattleTypes.TRAINER:
		await startTrainerBattle()
	
	#await showActivePokemons()
	
	#await UI.msgBox.finished
	#await UI.msgClosed
	
	await takeTurn()

func takeTurn():
	newTurn.emit()
	print("lalala")
	await effects.applyBattleEffect("InitBattleTurn")
	#SignalManager.Battle.Effects.applyAt.emit("InitBattleTurn")
	#await SignalManager.Battle.Effects.finished
	if stage == CONST.BATTLE_STAGES.SELECT_ACTION:
		print("active pokemons :" + str(activePokemons))
		for bs:BattleSpot in activeBattleSpots:# p:BattlePokemon in activePokemons:
			activeBattleSpot = bs
			active_pokemon.initTurn()
			#active_pokemon = p
			active_pokemon.selectAction()
			if active_pokemon.controllable:
				GUI.battle.playAnimation("SELECT_ACTION",{}, active_pokemon.battleSpot)
				await active_pokemon.actionSelected
				GUI.battle.stopAnimation("SELECT_ACTION")
			print(active_pokemon.Name + " selected " + CONST.BATTLE_ACTIONS.keys()[active_pokemon.selectedBattleChoice.type])
			
		stage = CONST.BATTLE_STAGES.DO_ACTION
		
	if stage == CONST.BATTLE_STAGES.DO_ACTION:
		orderPokemonByActionPriority()
		
		for bs:BattleSpot in turnPokemonOrder:
			activeBattleSpot = bs
			if active_pokemon!=null and !active_pokemon.fainted and !active_pokemon.opponentSide.isDefeated():
				print(active_pokemon.Name + " Effects("+ str(active_pokemon.activeAccumulatedEffects.size()) + "): ")
				for effect in active_pokemon.activeAccumulatedEffects:
					print(effect.name)
				await effects.applyBattleEffect("InitPKMNTurn")
				active_pokemon.doAction()
				await active_pokemon.actionFinished

				for spot:BattleSpot in activeBattleSpots:
					await spot.checkFainted()
				
				#Give exp to all implied pokemon
				SignalManager.Battle.ExperienceHandler.giveExp.emit()
				await SignalManager.Battle.ExperienceHandler.finished
				
				await effects.applyBattleEffect("EndPKMNTurn")

	await endTurn()
	if !battleFinished():
		takeTurn()
	else:
		await endBattle()
	
func initActivePokemons():
	var pk_per_side : int = 0
	var pk_per_part : int = 0
	if rules.mode == BattleRules.BattleModes.SINGLE:
		pk_per_side = 1
	elif rules.mode == BattleRules.BattleModes.DOUBLE:
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
	#self.playerSide.opponentSide = enemySide
	#self.enemySide.opponentSide = playerSide
	#enemySide.field.parentField = field
	#playerSide.field.parentField = field
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
#
#func addPersistentWeather(weather:CONST.WEATHER):
	#activeWeathereffect = BattleWeatherEffect.getWeather(weather).new()
	#
func addTemporaryWeather(weather:BattleEffect.Weather, minTurns: int, maxTurns: int):
	var newWeather:BattleEffect = BattleEffect.getWeather(weather).new()
	newWeather.minTurns = minTurns
	newWeather.maxTurns = maxTurns

#func removeWeather(weather:CONST.WEATHER = CONST.WEATHER.NONE):
	#if weather != CONST.NONE:
		##If we want to remove a concrete weather, check if this weather is the actual active weather. Otherwise, do nothing
		#if activeWeathereffect != null and activeWeathereffect.weatherType == weather:
			#activeWeathereffect = null
	#else:
		#activeWeathereffect = null
	#
func orderPokemonByActionPriority():
	turnPokemonOrder = activeBattleSpots# activePokemons
#	for p in activePokemons:
#		turnPokemonOrder.push_back(p)
	
	turnPokemonOrder.sort_custom(sortChoices)
	
func startWildBattle():
	for p:BattleSpot in enemySide.battleSpots:
		await p.showHPBar()
	await GUI.battle.showWildBattleMessage()
	#if enemySide.activePokemons.size() == 1:
		#await GUI.battle.showMessageWait("¡Un " + enemySide.activePokemons[0].Name + " salvaje te corta el paso!", 1.5)
		#await GUI.get_tree().create_timer(1.5).timeout
	await playerSide.showActivePokemons()
	
func startTrainerBattle():
	await enemySide.showActivePokemons()
	await playerSide.showActivePokemons()


#Funció que ordena els actions de cada pokemon actiu segons prioritat, per saber en quin ordre s'executarà cada atac/acció
func sortChoices(a : BattleSpot, b : BattleSpot):
	var pkmnA:BattlePokemon = a.activePokemon
	var pkmnB:BattlePokemon = b.activePokemon
	var choice_a = pkmnA.selectedBattleChoice
	var choice_b = pkmnB.selectedBattleChoice
	
	var unix_time: float = Time.get_unix_time_from_system()
	var unix_time_int: int = unix_time
	var dt: Dictionary = Time.get_datetime_dict_from_unix_time(unix_time)
	
	print(choice_a.priority)
	print(choice_b.priority)
	if choice_a.priority > choice_b.priority:
		return true
	elif choice_a.priority < choice_b.priority:
		return false
	else:
		if choice_a is BattleMoveChoice and choice_b is BattleMoveChoice:
			if pkmnA.getModStat(CONST.STATS.VEL) > pkmnB.getModStat(CONST.STATS.VEL):
				return true
			elif pkmnA.getModStat(CONST.STATS.VEL) < pkmnB.getModStat(CONST.STATS.VEL):
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
	if playerSide.escapedBattle or enemySide.escapedBattle:
		return true
	print("sides size " + str(sides.size()))
	for s in sides:
		if s.isDefeated():
			return true
	return false
	
func endTurn():
	stage = CONST.BATTLE_STAGES.SELECT_ACTION
	await effects.applyBattleEffect("EndBattleTurn")
	# es podria fer una senyal per l endTurn igual que vaig fer una pel newTurn?
	for bs:BattleSpot in activeBattleSpots:
		bs.endTurn()
	
	await handlePokemonChanges()
	#for spot:BattleSpot in activeBattleSpots:
		#if spot.activePokemon == null:
			#await spot.selectNextPokemon()
		#else:
			#spot.endTurn()
			#
	#if enemySide.pendingPokemonChange:
#
		##await GUI.battle.showNextPokemonMessage(enemySide.getChangedPokemon(), false, 1.5)
		#if !playerParticipant.pendingPokemonChange and rules.mode == CONST.BATTLE_MODES.SINGLE:
			#await GUI.battle.showNextPokemonMessage("¿Quieres cambiar de Pokémon?", false, 1.5)
			#for bs:BattleSpot in playerParticipant.battleSpots:
				#bs.selectNextPokemon()
		##enemySide.showPokemon()
		#
	#if playerSide.pendingPokemonChange:
		#await playerSide.showPokemons()
		#playerSide.showPokemon()
	#for p in activePokemons:
		#p.endTurn()

func handlePokemonChanges():
	for bs:BattleSpot in activeBattleSpots:
		if bs.activePokemon == null && !bs.controllable:
				bs.selectNextPokemon()
		
	var changePokemon:bool = playerParticipant.pendingPokemonChanges#(enemySide.pendingPokemonChanges && UI.showMessageYesNo("Quieres cambiar?") == MessageBox.YES) || playerParticipant.pendingPokemonChanges
	
	if changePokemon:
		var msgOption:int = await UI.showMessageYesNo("¿Usas el siguiente Pokémon?")
		if msgOption == MessageBox.YES:
			await playerParticipant.selectNextPokemons()
		else:
			if await playerParticipant.tryEscapeFromBattle():
				return
			else:
				await playerParticipant.selectNextPokemons()
				
	var showPokemonOrder:Array[BattleSpot] = activeBattleSpots.duplicate()
	showPokemonOrder.sort_custom(orderByShowPokemonOrder)
	for bs:BattleSpot in showPokemonOrder:
		if bs.pendingPokemonChanges:
			await bs.showNextPokemon()
			
# En primera posició els spots que controlem, i després els de la IA.
# Dintre de la IA, primer els enemics, i llavors el company.
func orderByShowPokemonOrder(a:BattleSpot, b:BattleSpot):
	if (!a.controllable and b.controllable) || (a.controllable and b.controllable):
		return true
	elif a.controllable and !b.controllable:
		return false
	elif !a.controllable and !b.controllable:
		if a.side.type == CONST.BATTLE_SIDES.ENEMY:
			return false
		else:
			return true
	return true

func endBattle():
	await GUI.fadeIn(1.3)
	effects.clear()
	UI.clear()
	queue_free()
	await GUI.get_tree().create_timer(1).timeout
	await GUI.fadeOut(3)
	
func queue_free():
	rules = null
	playerSide = null
	enemySide = null

	sides.clear()
	SignalManager.disconnectAll(newTurn)
	activePokemons.clear()
	active_pokemon = null
	SignalManager.Battle.ExperienceHandler.free.emit()
	expHandler = null
	turnPokemonOrder.clear()
	field.activeBattleEffects.clear()
	field = null

	
#func doCommonAnimation(root:Object, animName:String):
	#if FileAccess.file_exists("res://Animaciones/Batalla/General/Classes/" + str(animName) + ".gd") != null:
		#var animation:BattleCommonAnimation = load("res://Animaciones/Batalla/General/Classes/" + str(animName) + ".gd").new(root.animPlayer, animName)
		#print("lololol")
		##animation.addParameter("battleSpot", active_pokemon.battleSpot)
		#await animation.doAnimation()
		##await load("res://Animaciones/Batalla/General/Classes/"+str(animName)+".gd").new(animName).doAnimation()
