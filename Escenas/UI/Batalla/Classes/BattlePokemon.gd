class_name BattlePokemon

signal updateHP
signal updateEXP
signal actionSelected
signal actionFinished
signal levelChanged

var instance : PokemonInstance

var controllable : bool: # Indica si el pokemon el controlarà el Jugador o la IA
	get:
		return participant.controllable
var inBattleParty : bool # Indica si el pokemon forma part del party del battle (En el cas d'un combat doble de 2 entrenadors, per saber si ha estat seleccionat per formar par del party conjunt o no
var inBattle : bool:
	set(_inBattle):
		inBattle = _inBattle
		instance.inBattle = _inBattle
var participant : BattleParticipant # Indica a quin participant pertany (entrenador)
var side : BattleSide: # Indica a quin side forma part el pokemon
	get:
		return participant.side

var sideType:CONST.BATTLE_SIDES:
	get:
		return participant.side.type
		
var listEnemies : Array[BattlePokemon]:
	get:
		return side.opponentSide.activePokemons
var listAllies  : Array[BattlePokemon]:
	get:
		return getAllies()

var IA: BattleIA

var Name : String:
	get:
		return instance.Name
	set(value):
		Name = value 
var level : int:
	get:
		return instance.level
	set(value):
		instance.level = value 
var gender: CONST.GENEROS:
	get:
		return instance.gender
	set(value):
		gender = value 
var status: CONST.STATUS:
	get:
		return instance.status
	set(value):
		instance.status = value
var fainted : bool = false :
	get:
		return instance.fainted
var hp_total : int:
	get:
		return instance.hp_total
	set(value):
		instance.hp_total = value
var hp_actual : int:
	get:
		return instance.hp_actual
	set(value):
		instance.hp_actual = value
var attack : int:
	get:
		return instance.attack
var defense : int:
	get:
		return instance.defense
var speed : int:
	get:
		return instance.speed
var sp_attack : int:
	get:
		return instance.special_attack
var sp_defense : int:
	get:
		return instance.special_defense
var shiny : bool:
	get:
		return instance.shiny
var types : Array[Type]:
	get:
		return instance.types
var ability: int:
	get:
		return instance.ability_id
var front_sprite : Texture2D:
	get:
		return instance.battle_front_sprite
var back_sprite : Texture2D:
	get:
		return instance.battle_back_sprite
var battlerPlayerY: int:
	get:
		return instance.battlerPlayerY
var battlerEnemyY: int:
	get:
		return instance.battlerEnemyY
var battlerAltitude: int:
	get:
		return instance.battlerAltitude
#var trainer: Battler:
	#get:
		#return instance.trainer
var isWild: bool:
	get:
		return instance.isWild

var totalExp : int: # Es la quantitat d'experiencia que ha acumulat fins ara el pokemon
	get:
		return instance.totalExp
	set(_totalExp):
		instance.totalExp = _totalExp
var actualLevelExpBase : int: # Es l'experiencia base necessaria per arribar al nivell actual
	get:
		return instance.actualLevelExpBase
var nextLevelExpBase:int:
	get:
		return instance.nextLevelExpBase

var sprite : Texture2D
var HPbar : HPBar:
	get:
		return battleSpot.HPbar
#var animPlayer : AnimationPlayer:
	#get:
		#return battleSpot.animPlayer

var priority : int = 0 # indica quina prioritat té el pkmn dintre el battle en aquell turn. Per saber en quin ordre atacarà
var moves : Array[BattleMove]

var selected_action : BattleChoice
var selected_move : BattleMove = null

var canAttack : bool = true

var activeEffectsFlags : Array[BattleEffect] = [] #Array[CONST.MOVE_EFFECTS] = []

var battleStatsMod : Array[int] = [0,0,0,0,0,0,0,0]  #Modificadors d'stats. El primer es HP, no es farà servir mai
var listPokemonBattledAgainst : Array[BattlePokemon] = [] #Number of pokemon opponents that have participied in the battle to defeat the pokemon
var battleSpot: BattleSpot

var battleMessageName: String:
	get():
		var msgName:String = ""
		if controllable:
			msgName = Name
		else:	
			if isWild:
				msgName = "El " + Name + " salvaje"
			else:
				msgName = "El " + Name + " enemigo"
		return msgName
#func _init(_pokemon : PokemonInstance, _IA: BattleIA):
#func create(_pokemon : PokemonInstance, _IA: BattleIA):
func _init(_pokemon: PokemonInstance, _IA: BattleIA = null):
	instance = _pokemon
			#bp.isWild = _participant.type == CONST.BATTLER_TYPES.WILD_POKEMON
		#bp.controllable = _controllable
	#instance.battleInstance = self
	#Name = _pokemon.Name
	#level = _pokemon.level
	#types = _pokemon.types
	#gender = _pokemon.gender
	#status = _pokemon.status
	#hp_total = _pokemon.hp_total
	#hp_actual = _pokemon.hp_actual
	#attack = _pokemon.attack
	#defense = _pokemon.defense
	#speed = _pokemon.speed
	#sp_attack = _pokemon.special_attack
	#sp_defense = _pokemon.special_defense
	#ability = _pokemon.ability_id
	#
	#front_sprite = _pokemon.battle_front_sprite
	#back_sprite = _pokemon.battle_back_sprite
	#
	#battlerPlayerY = _pokemon.base.battlerPlayerY
	#battlerEnemyY = _pokemon.base.battlerEnemyY
	#battlerAltitude = _pokemon.base.battlerAltitude
	#shiny = _pokemon.shiny
	
	if hp_actual > 0:
		fainted = false
	else:
		fainted = true

	setIA(_IA)
	
	loadMoves()

func setIA(_IA:BattleIA):
	if _IA != null:
		var pkmnIA = _IA.duplicate()
		if !pkmnIA.pokemon_assigned():
			pkmnIA.assign_pokemon(self)
		self.IA = pkmnIA
		
func setBattleSpot(battleSpot:BattleSpot):
		self.battleSpot = battleSpot

func loadMoves():
	for m in instance.movements:
		var battleMove = BattleMove.new(m, self)
		moves.push_back(battleMove)

func clear():
	listAllies.clear()
	listEnemies.clear()
	
	
func loadPokemon(pokemon:PokemonInstance):
	#init(pokemon)
	print("loading " + pokemon.Name)
	print("enemy size: " + str(side.opponentSide.activePokemons.size()))
	GUI.battle.loadActivePokemon(self)
	print("enemy size: " + str(side.opponentSide.activePokemons.size()))
	
func unloadPokemon():
	instance = null
	moves.clear()
	GUI.battle.removeActivePokemon(self)
		
func initTurn():
	if controllable:
		connectActions()


func endTurn():
	if controllable:
		disconnectActions()
	canAttack = true

func connectActions():
	GUI.battle.selectMove.connect(Callable(self, "selectMove"))
	GUI.battle.changePokemon.connect(Callable(self, "changePokemon"))
	GUI.battle.useBag.connect(Callable(self, "useBag"))
	GUI.battle.exitBattle.connect(Callable(self, "exitBattle"))
	
func disconnectActions():
	if GUI.battle.selectMove.is_connected(Callable(self, "selectMove")):
		GUI.battle.selectMove.disconnect(Callable(self, "selectMove"))
	if GUI.battle.changePokemon.is_connected(Callable(self, "changePokemon")):
		GUI.battle.changePokemon.disconnect(Callable(self, "changePokemon"))
	if GUI.battle.useBag.is_connected(Callable(self, "useBag")):
		GUI.battle.useBag.disconnect(Callable(self, "useBag"))
	if GUI.battle.exitBattle.is_connected(Callable(self, "exitBattle")):
		GUI.battle.exitBattle.disconnect(Callable(self, "exitBattle"))

func updateBattleInfo():
	clear()
	print("enemy size: " + str(side.opponentSide.activePokemons.size()))
	#if p.side.type == CONST.BATTLE_SIDES.PLAYER:
	setEnemies(side.opponentSide.activePokemons)
	setAllies(side.activePokemons)
	#for e in listEnemies:
		#if !listPokemonBattledAgainst.has(e):
			#listPokemonBattledAgainst.push_back(e)
	print("enemy size: " + str(side.opponentSide.activePokemons.size()))

func setEnemies(_enemies : Array[BattlePokemon]):
	listEnemies.clear()
	listEnemies = _enemies
	
func setAllies(_allies : Array[BattlePokemon]):
	listAllies.clear()
	for a in _allies:
		if a != self:
			listAllies.push_back(a)
			
func getAllies():
	var list:Array[BattlePokemon]
	for a:BattlePokemon in side.activePokemons:
		if a != self:
			list.push_back(a)
	return list
	
func selectAction():
	if controllable:
		GUI.battle.showActionsPanel()
		#await GUI.battle.actionSelected
		
#		doAction()
		
	else:
		print("IA doing action things")
		IA.selectAction()
		actionSelected.emit()
		
func doAction():
	if selected_action.type == CONST.BATTLE_ACTIONS.LUCHAR: # is BattleMoveChoice: #LUCHAR
		side.restartEscapeAttempts()
		await selected_action.doMove()
		actionFinished.emit()
	elif selected_action.type == CONST.BATTLE_ACTIONS.POKEMON: #is BattleSwitchChoice: #POKEMON
		await selected_action.switchPokemon()
		#await selected_action.pokemonSwitched
		actionFinished.emit()
	elif selected_action.type == CONST.BATTLE_ACTIONS.MOCHILA: # is BattleItemChoice: #MOCHILA
		pass
		#actionFinished.emit()
	elif selected_action.type == CONST.BATTLE_ACTIONS.HUIR: #HUIR
		if await tryEscapeFromBattle():
			await GUI.battle.controller.endBattle()
		else:
			actionFinished.emit()

#func selectMove():
	#if controllable:
		#print("nse")
		#GUI.battle.showMovesPanel()
		#await GUI.battle.moveSelected
		#print("uea")
		#await GUI.battle.showTargetSelection()
		##await GUI.battle.targetSelected
		#print("eeee")
		#
		#actionSelected.emit()
	#else:
		#print("IA doing move things")
		#IA.selectMove()
		#

#func doMove(choice: BattleMoveChoice):
	#print(Name + " doing move " + choice.move.Name)
	#
	#await applyPreviousEffects()
	#
	#if canAttack:
		#await choice.move.use(choice.target)
	#
	#await applyLaterEffects()

func selectMove():
	#selected_action=BattleChoice.new(CONST.BATTLE_ACTIONS.POKEMON, 6)
	selected_action=BattleMoveChoice.new(self)
	selected_action.selectMove()
	await selected_action.moveSelected
	actionSelected.emit()
	
func changePokemon():
	#selected_action=BattleChoice.new(CONST.BATTLE_ACTIONS.POKEMON, 6)
	selected_action=BattleSwitchChoice.new(self)
	await selected_action.showParty()
	#If a pokemon has been selected, go forward. Else the action still has to be selected
	if selected_action.switchInPokemon != null:
		actionSelected.emit()

	
func useBag():
	selected_action=BattleChoice.new(CONST.BATTLE_ACTIONS.MOCHILA, 6)
	actionSelected.emit()

	
func exitBattle():
	selected_action=BattleChoice.new(CONST.BATTLE_ACTIONS.HUIR, 6)
	actionSelected.emit()
	
# S'aplica la fórmula de les primeres 4 generacions	
func getExpGained(opponent : BattlePokemon):
	var a = 1 # if fainted pokemon is wild or from a trainer
	var b = opponent.instance.base_experience #base exp of fainted pokemon
	var lf = opponent.level #level of fainted pokemon
	var e = 1 # TO DO winning pokemon has lucky egg equipped or not
	var s:float = 1.0 # Repartir Exp
	var t = 1 # if pokemon owner is the original owner or not
	
	if !opponent.isWild: 
		a = 1.5
	
	if instance.hasItemEquipped(15): #TO DO if winning pokemon has lucky egg equipped
		e = 1.5
	
	if !participant.hasExpAllEquiped(): 
		s = float(opponent.listPokemonBattledAgainst.size())
	else:
		if opponent.listPokemonBattledAgainst.has(self):
			s = opponent.listPokemonBattledAgainst.size() * 2
		else:
			s = participant.getExpAllEquipedCount() * 2
		
	if instance.trainer_id != GAME_DATA.player_id:
		t = 1.5
	
	return floor(floor(floor(floor((b * lf / 7) * (1.0 / s)) * e) * a) * t)
	
func take_damage(amount):
	hp_actual -= amount
	hp_actual = max(0, hp_actual)
	HPbar.updateHP(hp_actual)
	await HPbar.updated

	#updateHP.emit(hp_actual)
	
func heal(amount):#, type:CONST.HEAL_TYPE): #type MOVE or OBJECT
	#L'animació de heal es farà desde la funció del move, ailment, o item que toqui
	#if type == CONST.HEAL_TYPE.ITEM:
		#await playAnimation("HEAL")
	#await BattleAnimationList.new().getCommonAnimation("Heal").doAnimation(battleSpot)
	hp_actual += amount
	hp_actual = min(hp_actual, hp_total)
	HPbar.updateHP(hp_actual)
	await HPbar.updated
	#updatePokemonState()

func HPpercentageLeft() -> float:
	return float(hp_actual)/float(hp_total)
	
func hasFullHealth():
	return hp_actual == hp_total
	
func hasWorkingAbility(a):
	return ability == a

func hasWorkingEffect(e):
	return activeEffectsFlags.has(e)

func hasAlly():
	return listAllies.size() > 0
	
# Funció que retorna l'stat seleccionat aplicant-li el modificador que tingui el pokemon aquell moment
# per aquell stat durant el combat. Utitzat per exemple en el calculateDamage.
func getModStat(stat : CONST.STATS):
	if stat == CONST.STATS.ATA:
		return attack * CONST.BATTLE_STAGE_MULT_STATS[battleStatsMod[CONST.STATS.ATA]]
	elif stat == CONST.STATS.DEF:
		return defense * CONST.BATTLE_STAGE_MULT_STATS[battleStatsMod[CONST.STATS.DEF]]
	elif stat == CONST.STATS.ATAESP:
		return sp_attack * CONST.BATTLE_STAGE_MULT_STATS[battleStatsMod[CONST.STATS.ATAESP]]
	elif stat == CONST.STATS.DEFESP:
		return sp_defense * CONST.BATTLE_STAGE_MULT_STATS[battleStatsMod[CONST.STATS.DEFESP]]
	elif stat == CONST.STATS.VEL:
		return speed * CONST.BATTLE_STAGE_MULT_STATS[battleStatsMod[CONST.STATS.VEL]]


func print_pokemon():
	print("----------- " + Name + " Nv. " + str(level) + " -----------")
	print("+++++ STATS +++++")
	print("HP: " + str(hp_actual) + "/" + str(hp_total))
	print("ATTACK: " + str(attack))
	print("DEFENSE: " + str(defense))
	print("SP. ATTACK: " + str(sp_attack))
	print("SP. DEFENSE: " + str(sp_defense))
	print("SPEED: " + str(speed))	
	
func print_moves():
	print("+++++ MOVIMIENTOS +++++")
	for m in moves:
		m.print_move()

func updatePokemonState():
	if fainted:
		#fainted = true
		print(Name + " fainted!")
		await setDefeated()
		
func changeStatus(_attacker : BattlePokemon, _status : CONST.AILMENTS):
	if status == CONST.STATUS.OK:
		if _status == CONST.AILMENTS.SLEEP:
			status = CONST.STATUS.SLEEP
		elif _status == CONST.AILMENTS.POISON:
			status = CONST.STATUS.POISON
		elif _status == CONST.AILMENTS.BURN:
			status = CONST.STATUS.BURNT
		elif _status == CONST.AILMENTS.PARALYSIS:
			await playAnimation("PARALYSIS")
			status = CONST.STATUS.PARALISIS
		elif _status == CONST.AILMENTS.FREEZE:
			status = CONST.STATUS.FROZEN
		
		if status != CONST.STATUS.OK:
			addEffect(load("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[_status]+".gd").new(self))
			#addEffect(BattleMoveAilmentEffect.new(true, _status, _attacker, self))
		
	if _status == CONST.AILMENTS.NONE:
		status = CONST.STATUS.OK
		removeStatus(load("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[_status]+".gd").new(self))
		#removeStatus(BattleMoveAilmentEffect.new(true, _status, _attacker, self))

		
	HPbar.updateStatusUI()

func applyPreviousEffects():
	for effect in activeEffectsFlags:
		await effect.applyPreviousEffects()
	
func applyLaterEffects():
	for effect in activeEffectsFlags:
		await effect.applyLaterEffects()

func setDefeated():
	
	await playAnimation("DEFEATED",{'Side':sideType})
	inBattle = false
	#Mostro missatge pokemon debilitat
	await GUI.battle.msgBox.showDefeatedPKMNMessage(self)
	
func giveExpAtDefeat():
	for p:BattlePokemon in listPokemonBattledAgainst:
		var expGained = p.getExpGained(self)
		await GUI.battle.msgBox.showGainedEXPMessage(p, expGained)
		print("kik")
		if p.inBattle:
			p.HPbar.updateEXP(p.totalExp+expGained)
			await p.HPbar.updated
		else:
			p.totalExp += expGained
		print("lel")
	#Give Exp to all PKMNs with Exp. All equipped
	for par:BattleParticipant in side.opponentSide.participants:
		for p:BattlePokemon in par.getPKMNwithExpAll():
			var expGained = p.getExpGained(self)
			p.totalExp += expGained
			await GUI.battle.msgBox.showGainedEXPMessage(p, expGained)
	
func addEffect(effect : BattleEffect):
	activeEffectsFlags.push_back(effect)
	
func removeStatus(effect : BattleMoveAilmentEffect):
	var delete
	for e in activeEffectsFlags:
		if e.isStatus:
			delete = e
			break
	activeEffectsFlags.erase(delete)

func levelUP():
	instance.levelUP()
	HPbar.updateUI()
	await GUI.battle.msgBox.showLevelUpMessage(self, level)
	await GUI.battle.msgBox.showLevelUpStats(self)
	levelChanged.emit()

func hasItemEquipped(item_id:int):
	return instance.hasItemEquipped(item_id)
	
#Calculate the chances to escapte from the battle and its success
func tryEscapeFromBattle():
	var playerSpeed = speed
	side.escapeAttempts += 1
	var success:bool = true
	for e in listEnemies:
		var enemySpeed:float = e.speed
		if playerSpeed > enemySpeed:
			success = true
		else:
			var speedChances:float = floor(((playerSpeed * 128.0 / enemySpeed) + 30.0) * side.escapeAttempts)
			randomize()
			var rand:int = randi() % 256
			success = rand < fmod(speedChances, 256)
		if !success:
			break
	await GUI.battle.msgBox.showExitMessage(success)
	return success

func enterBattle(update:bool=false):
	battleSpot.enterPokemon(self, update)

func quitBattle(update:bool=false):
	battleSpot.quitPokemon(update)

#func doAnimation(animName:String):
	#if FileAccess.file_exists("res://Animaciones/Batalla/Pokemon/Classes/" + str(animName) + ".gd") != null:
		#var animation:BattlePokemonAnimation = load("res://Animaciones/Batalla/Pokemon/Classes/" + str(animName) + ".gd").new(self)
		#print("lololol")
		#await animation.doAnimation()

func playAnimation(animName:String, animParams:Dictionary={}):
	#var animParams:Dictionary = {'Target':target}
	SignalManager.BATTLE.playAnimation.emit(animName.to_upper(),animParams, battleSpot)
	await SignalManager.ANIMATION.finished_animation

func get_path_to(node:Node2D):
	return battleSpot.get_path_to(node)

func _to_string():
	return Name
	
