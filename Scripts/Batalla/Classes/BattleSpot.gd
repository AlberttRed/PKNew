extends Node2D

class_name BattleSpot

@onready var sprite:Sprite2D = $Sprite
#@onready var animPlayer = $AnimationPlayer

var participant : BattleParticipant# Indica a quin participant pertany (entrenador)
var activePokemon:BattlePokemon #Indica quin Pokémon està en aquest spot en aquest moment
var nextPokemon: BattlePokemon #Indica quin Pokemon serà el següent en entrar
var side:BattleSide:
	get:
		return participant.side
var opponentSide : BattleSide:
	get:
		return side.opponentSide
@export var HPbar:HPBar

var controllable:bool:
	get:
		return participant.controllable

var pendingPokemonChanges:bool:
	get:
		return nextPokemon != null or (nextPokemon == null and activePokemon == null and participant.hasAvailablePokemon)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func initSprite(type : CONST.BATTLE_SIDES):
	sprite.visible = activePokemon.isWild
	if type == CONST.BATTLE_SIDES.PLAYER:
		#var sprite2:Texture2D = activePokemon.back_sprite as Texture2D
		var texture:Texture2D = ImageTexture.new().create_from_image(activePokemon.back_sprite.atlas.get_image().get_region(activePokemon.back_sprite.region))
		texture.set_size_override(texture.get_size())
		#var reg = activePokemon.back_sprite.region;
		#var image = activePokemon.back_sprite.atlas.get_image().get_region(activePokemon.back_sprite.region);
		#img_tex.create_from_image(activePokemon.back_sprite.atlas.get_image().get_region(activePokemon.back_sprite.region));
		sprite.texture = texture#activePokemon.back_sprite as Texture2D
	elif type == CONST.BATTLE_SIDES.ENEMY:
		#var sprite2:Texture2D = activePokemon.front_sprite as Texture2D
		var texture:Texture2D = ImageTexture.new().create_from_image(activePokemon.front_sprite.atlas.get_image().get_region(activePokemon.front_sprite.region))

		#img_tex.create_from_image(activePokemon.front_sprite.atlas.get_image().get_region(activePokemon.front_sprite.region));
		sprite.texture = texture#activePokemon.front_sprite as Texture2D
		
func initPokemonUI():
	#playAnimation("RESET")
	#animPlayer.play("GLOBAL/RESET")
	initSprite(side.type)
	setSpritePosition()
	HPbar.init(activePokemon)
	HPbar.updateUI()
	
	
func setSpritePosition():
	var y_position = 0
	var initial_pos :int = 0
	var battleY : int = 0
	var altitude : int = 0
	var offset = Vector2(0, 0)
	
	if side.type == CONST.BATTLE_SIDES.PLAYER:
		
		#Afegim 20 perquè en la conversió a ImageTexture queda l'sprite elevat
		offset = Vector2(0, 20)
		
		battleY = activePokemon.battlerPlayerY * 2
	
	elif side.type == CONST.BATTLE_SIDES.ENEMY:
		if sprite.texture.get_height() == 160:
			initial_pos = 0
		elif sprite.texture.get_height() == 190:
			initial_pos = 16
		
		battleY = activePokemon.battlerEnemyY * 2
		altitude = activePokemon.battlerAltitude * 2
		
	sprite.position.y = y_position - initial_pos + battleY - altitude
	sprite.offset = offset
	
func loadActivePokemon(pokemon:BattlePokemon):
	activePokemon = pokemon
	#activePokemon.playAnimation.connect(Callable(self, "playAnimation"))
	activePokemon.setBattleSpot(self)
	activePokemon.inBattle = true
	activePokemon.initAbility()
	GUI.battle.controller.newTurn.connect(func(): activePokemon.turnsInBattle +=1)
	if activePokemon.sideType == CONST.BATTLE_SIDES.PLAYER:
		if GUI.battle.controller.rules.mode == CONST.BATTLE_MODES.SINGLE:
			self.position = CONST.BATTLE.BACK_SINGLE_SPRITE_POS
		#pokemon.reparent($playerBase)
		#pokemon.get_node("Shadow").visible=false
	elif activePokemon.sideType == CONST.BATTLE_SIDES.ENEMY:
		if GUI.battle.controller.rules.mode == CONST.BATTLE_MODES.SINGLE:
			self.position = CONST.BATTLE.FRONT_SINGLE_SPRITE_POS
		#pokemon.reparent($enemyBase)
		$Shadow.visible=true
	initPokemonUI()
	self.visible = true
	GUI.battle.controller.updateActivePokemonsInfo()
	
	#for m:BattleMove in activePokemon.moves:
		#m.playAnimation.connect(Callable(self, "playAnimation"))

func removeActivePokemon():
	self.visible = false
	activePokemon.inBattle = false
	#activePokemon.instance = null
	#activePokemon.activeAccumulatedEffects.clear()
	#activePokemon.activeBattleEffects.clear()
	await GUI.battle.controller.effects.clearPokemonEffects(activePokemon)
	#SignalManager.Battle.Effects.clear.emit(activePokemon)
	#await SignalManager.Battle.Effects.finished
	activePokemon.clear()
	activePokemon.disconnectActions()
	HPbar.clearUI()
	#activePokemon.playAnimation.disconnect(Callable(self, "playAnimation"))
	if activePokemon.sideType == CONST.BATTLE_SIDES.PLAYER:
		pass
		#pokemon.reparent($playerBase/Party)
		#pokemon.get_node("Shadow").visible=false
		#pokemon.initPokemonUI($playerBase/HPBarA)
	elif activePokemon.sideType == CONST.BATTLE_SIDES.ENEMY:
		#pokemon.reparent($enemyBase/Party)
		$Shadow.visible=false
		#pokemon.initPokemonUI($enemyBase/HPBarA)
	activePokemon.setBattleSpot(null)
	#for m:BattleMove in activePokemon.moves:
		#m.playAnimation.disconnect(Callable(self, "playAnimation"))
	activePokemon = null
	GUI.battle.controller.updateActivePokemonsInfo()
	
func setParticipant(participant:BattleParticipant):
	self.participant = participant
	participant.assignBattleSpot(self)
	
func setSide(_side:BattleSide):
	self.side = _side
	
func swapPokemon(enterPokemon:BattlePokemon):
	await quitPokemon()
	loadActivePokemon(enterPokemon)
	await enterPokemon(enterPokemon)
	
func enterPokemon(pokemon:BattlePokemon, update:bool=false):
	#loadActivePokemon(pokemon)
	if !pokemon.isWild:
		if side.type == CONST.BATTLE_SIDES.ENEMY:
			await playAnimation("ENEMY_THROWBALL",{'PokemonName': pokemon.Name})
		else:
			#await GUI.battle.showMessage("¡Adelante " + pokemon.Name + "!", false, 0.5)
			await playAnimation("PLAYER_THROWBALL",{'PokemonName': pokemon.Name})#("PLAYER_THROWBALL")
		#await animPlayer.playAnimation("IN_BATTLE")
		#await activePokemon.doAnimation("INOUT_BATTLE")
	
func quitPokemon(update:bool=false):
	await GUI.battle.showMessage("¡" + activePokemon.Name + ", cambio! ¡Vuelve aquí!", false, 0.5)
	await playAnimation("OUT_BATTLE")
	#await hideHPBar()
	#await animPlayer.playAnimation("OUT_BATTLE")
	await removeActivePokemon()

func checkFainted():
	if activePokemon != null and activePokemon.fainted and activePokemon.inBattle:
		await activePokemon.setDefeated()
		removeActivePokemon()
	
func showHPBar():
	await GUI.battle.showHPBarUI(HPbar)

func hideHPBar():
	await GUI.battle.hideHPBarUI(HPbar)

func addBattleEffect(effect : BattleEffect):
	if effect == null:
		return
	SignalManager.Battle.Effects.add.emit(effect, activePokemon)
	
func endTurn():
	if activePokemon!=null:
		activePokemon.endTurn()
		
func selectNextPokemon():
	#var selectedPokemon = null
	if !participant.hasAvailablePokemon:
		nextPokemon = null
		return
	if participant.controllable:
		nextPokemon = await GUI.battle.showParty()
	#else:
		#IA.selectNextPokemon()

func showNextPokemon():
	if activePokemon == null:
		loadActivePokemon(nextPokemon)
		await enterPokemon(nextPokemon)
	else:
		await swapPokemon(nextPokemon)
	nextPokemon = null

func playAnimation(animation:String, animParams:Dictionary = {}):
	SignalManager.Battle.Animations.playAnimation.emit(animation, animParams, self)
	await SignalManager.Animations.finished_animation
	#await GUI.battle.playAnimation(animation, animParams, self)
