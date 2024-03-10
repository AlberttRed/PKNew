class_name BattlePokemon

signal updateHP
signal actionSelected
signal actionFinished

var instance : PokemonInstance

var controllable : bool # Indica si el pokemon el controlarà el Jugador o la IA
var inBattleParty : bool # Indica si el pokemon forma part del party del battle (En el cas d'un combat doble de 2 entrenadors, per saber si ha estat seleccionat per formar par del party conjunt o no
var participant : BattleParticipant # Indica a quin participant pertany (entrenador)
var side : BattleSide: # Indica a quin side forma part el pokemon
	get:
		return participant.side
var listEnemies : Array[BattlePokemon] = []
var listAllies  : Array[BattlePokemon] = []
var listPokemonBattledAgainst : Array[BattlePokemon] = [] #Number of pokemon opponents that have participied in the battle to defeat the pokemon

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
		return hp_actual == 0
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
		return side.type == CONST.BATTLE_TYPES.WILD

var sprite : Texture2D
var HPbar : Node2D = null
var statusUI : Node2D = null
var battleNode : Node2D = null
var animPlayer : AnimationPlayer

var priority : int = 0 # indica quina prioritat té el pkmn dintre el battle en aquell turn. Per saber en quin ordre atacarà
var moves : Array[BattleMove]

var selected_action : BattleChoice
var selected_move : BattleMove = null

var canAttack : bool = true

var activeEffectsFlags : Array[BattleEffect] = [] #Array[CONST.MOVE_EFFECTS] = []

var battleStatsMod : Array[int] = [0,2,0,0,0,0,0,0]  #Modificadors d'stats. El primer es HP, no es farà servir mai
	
func _init(_pokemon : PokemonInstance, _IA: BattleIA):
	instance = _pokemon
	
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
	
	
	for m in _pokemon.movements:
		var battleMove = BattleMove.new(m, self)
		moves.push_back(battleMove)
		
	if _IA != null:
		if !_IA.pokemon_assigned():
			_IA.assign_pokemon(self)
	
	IA = _IA
		
		
func initTurn():
	if controllable:
		GUI.battle.selectMove.connect(Callable(self, "selectMove"))
		GUI.battle.changePokemon.connect(Callable(self, "changePokemon"))
		GUI.battle.useBag.connect(Callable(self, "useBag"))
		GUI.battle.exitBattle.connect(Callable(self, "exitBattle"))


func endTurn():
	if controllable:
		GUI.battle.selectMove.disconnect(Callable(self, "selectMove"))
		GUI.battle.changePokemon.disconnect(Callable(self, "changePokemon"))
		GUI.battle.useBag.disconnect(Callable(self, "useBag"))
		GUI.battle.exitBattle.disconnect(Callable(self, "exitBattle"))
	canAttack = true


func setEnemies(_enemies : Array[BattlePokemon]):
	listEnemies.clear()
	listEnemies = _enemies
	
func setAllies(_allies : Array[BattlePokemon]):
	listAllies.clear()
	for a in _allies:
		if a != self:
			listAllies.push_back(a)
	
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
			await doMove(selected_action)
	elif selected_action.type == CONST.BATTLE_ACTIONS.POKEMON: #is BattleSwitchChoice: #POKEMON
		pass
	elif selected_action.type == CONST.BATTLE_ACTIONS.MOCHILA: # is BattleItemChoice: #MOCHILA
		pass
	else: #HUIR
		pass
	actionFinished.emit()
		
func selectMove():
	if controllable:
		print("nse")
		GUI.battle.showMovesPanel()
		await GUI.battle.moveSelected
		print("uea")
		await GUI.battle.showTargetSelection()
		#await GUI.battle.targetSelected
		print("eeee")
		
		actionSelected.emit()
	else:
		print("IA doing move things")
		IA.selectMove()
		

func doMove(choice: BattleMoveChoice):
	print(Name + " doing move " + choice.move.Name)
	
	await applyPreviousEffects()
	
	if canAttack:
		await choice.move.use(choice.target)
	
	await applyLaterEffects()
	
func changePokemon():
	actionSelected.emit()
	pass
	
func useBag():
	actionSelected.emit()
	pass
	
func exitBattle():
	actionSelected.emit()
	pass
	
# S'aplica la fórmula de les primeres 4 generacions	
func getExpGained(opponent : BattlePokemon):
	var a = 1 # if fainted pokemon is wild or from a trainer
	var b = opponent.instance.base_experience #base exp of fainted pokemon
	var lf = opponent.level #level of fainted pokemon
	var e = 1 # TO DO winning pokemon has lucky egg equipped or not
	var s = 1 # Repartir Exp
	var t = 1 # if pokemon owner is the original owner or not
	
	if !opponent.isWild: 
		a = 1.5
	
	if instance.hasItemEquipped(15): #TO DO if winning pokemon has lucky egg equipped
		e = 1.5
	
	if !participant.hasExpAllEquiped(): 
		s = opponent.listPokemonBattledAgainst.size()
	else:
		if opponent.listPokemonBattledAgainst.has(self):
			s = opponent.listPokemonBattledAgainst.size() * 2
		else:
			s = participant.getExpAllEquipedCount() * 2
		
	if instance.trainer_id != GAME_DATA.player_id:
		t = 1.5
	return (b * lf / t) * (1 / s) * e * a * t
	
func take_damage(amount):
	await BattleAnimationList.new().getCommonAnimation("PokemonHit").doAnimation(self)
	hp_actual -= amount
	hp_actual = max(0, hp_actual)
	HPbar.updateHP(hp_actual)
	await HPbar.updated
	await updatePokemonState()
	#updateHP.emit(hp_actual)
	
func heal(amount):
	await BattleAnimationList.new().getCommonAnimation("Heal").doAnimation(self)
	hp_actual += amount
	hp_actual = max(hp_actual, hp_total)
	HPbar.updateHP(hp_actual)
	await HPbar.updated
	updatePokemonState()

func initSprite(type : CONST.BATTLE_SIDES):
	if type == CONST.BATTLE_SIDES.PLAYER:
		sprite = back_sprite
	elif type == CONST.BATTLE_SIDES.ENEMY:
		sprite = front_sprite
		
func initPokemonUI(pokemonNode : Node2D, hPBarNode : Node2D):
	battleNode = pokemonNode
	animPlayer = pokemonNode.get_node("AnimationPlayer")
	initSprite(side.type)
	pokemonNode.get_node("Sprite").texture = sprite
	setSpritePosition(pokemonNode.get_node("Sprite"))
	initHPBarUI(hPBarNode)
	
	
func initHPBarUI(hPBarNode : Node2D):
	hPBarNode.get_node("Name/lblName").text = Name
	hPBarNode.get_node("lblLevel").text = "Nv" + str(level)
	#hPBarNode.get_node("lblHP").text = str(pokemonInstance.hp_actual) + "/" + str(pokemonInstance.hp_total)
	if gender == CONST.GENEROS.HEMBRA:
		hPBarNode.get_node("Name/lblGender").text = "♀"
		hPBarNode.get_node("Name/lblGender").set("Label/colors/font_color", Color(0.97254902124405, 0.34509804844856, 0.15686275064945))
	elif gender == CONST.GENEROS.MACHO:
		hPBarNode.get_node("Name/lblGender").text = "♂"
		hPBarNode.get_node("Name/lblGender").set("Label/colors/font_color", Color(0.18823529779911, 0.37647059559822, 0.84705883264542))
	
	else:
		hPBarNode.get_node("Name/lblGender").text = ""
	
	statusUI = hPBarNode.get_node("Status")
	
	updateStatusUI()
	
	hPBarNode.get_node("health_bar").setHPBar(self)
	

func clearHPBarUI(hPBarNode : Node2D):
	hPBarNode.get_node("Name/lblName").text = ""
	hPBarNode.get_node("lblLevel").text = ""
	hPBarNode.get_node("Name/lblGender").text = ""
	statusUI.hide()
	hPBarNode.get_node("health_bar").clear(self)

func setSpritePosition(sprite : Sprite2D):
	var y_position = 0
	var initial_pos :int = 0
	var battleY : int = 0
	var altitude : int = 0
	
	if side.type == CONST.BATTLE_SIDES.PLAYER:
		
		battleY = battlerPlayerY * 2
	
	elif side.type == CONST.BATTLE_SIDES.ENEMY:
		if sprite.texture.get_height() == 160:
			initial_pos = 0
		elif sprite.texture.get_height() == 190:
			initial_pos = 16
		
		battleY = battlerEnemyY * 2
		altitude = battlerAltitude * 2
		
	sprite.position.y = y_position - initial_pos + battleY - altitude

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
	if HPpercentageLeft() == 0.0:
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
			status = CONST.STATUS.PARALISIS
		elif _status == CONST.AILMENTS.FREEZE:
			status = CONST.STATUS.FROZEN
		
		if status != CONST.STATUS.OK:
			addEffect(BattleAilmentEffect.new(true, _status, _attacker, self))
		
	if _status == CONST.AILMENTS.NONE:
		status = CONST.STATUS.OK
		removeStatus(BattleAilmentEffect.new(true, _status, _attacker, self))

		
	updateStatusUI()

func applyPreviousEffects():
	for effect in activeEffectsFlags:
		await effect.applyPreviousEffects()
	
func applyLaterEffects():
	for effect in activeEffectsFlags:
		await effect.applyLaterEffects()

func updateStatusUI():
	if status != CONST.STATUS.OK:
		statusUI.visible = true
		statusUI.region_rect = Rect2(0, 16*(status-1), 44, 16)
	else:
		statusUI.visible = false

func setDefeated():
	#Mostro animació pokemon debilitat
	# TO DO
	giveExpAtDefeat()
	#Mostro missatge pokemon debilitat
	await GUI.battle.msgBox.showDefeatedPKMNMessage(self)
	
func giveExpAtDefeat():
	for p:BattlePokemon in listPokemonBattledAgainst:
		var exp = p.getExpGained(self)
		print("¡" + p.Name + " ha ganado " + str(exp) + " Puntos de Experiencia!")
	#Give Exp to all PKMNs with Exp. All equipped
	for par:BattleParticipant in side.opponentSide.participants:
		for p:BattlePokemon in par.getPKMNwithExpAll():
			var exp = p.getExpGained(self)
			print("¡" + p.Name + " ha ganado " + str(exp) + " Puntos de Experiencia!")
	
	
func addEffect(effect : BattleEffect):
	activeEffectsFlags.push_back(effect)
	
func removeStatus(effect : BattleAilmentEffect):
	var delete
	for e in activeEffectsFlags:
		if e.isStatus:
			delete = e
			break
	activeEffectsFlags.erase(delete)
		
	
func queue_free():
	participant.queue_free()
	side.queue_free()
	if listAllies != null:
		for p in listAllies:
			p.queue_free()
	listAllies.clear()
	
	if listEnemies != null:
		for p in listEnemies:
			p.queue_free()
	listEnemies.clear()
	free()
