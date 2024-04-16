extends Node2D

class_name BattleSpot

@onready var sprite:Sprite2D = $Sprite
@onready var animPlayer:AnimationPlayer = $AnimationPlayer

var participant : BattleParticipant # Indica a quin participant pertany (entrenador)
var activePokemon:BattlePokemon #Indica quin Pokémon està en aquest spot en aquest moment
var side:BattleSide
var HPbar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func initSprite(type : CONST.BATTLE_SIDES):
	if type == CONST.BATTLE_SIDES.PLAYER:
		sprite.texture = activePokemon.back_sprite
	elif type == CONST.BATTLE_SIDES.ENEMY:
		sprite.texture = activePokemon.front_sprite
		
func initPokemonUI():
	initSprite(side.type)
	setSpritePosition()
	animPlayer.play("GLOBAL/RESET")
	HPbar.init(activePokemon)
	HPbar.updateUI()
	
	
func setSpritePosition():
	var y_position = 0
	var initial_pos :int = 0
	var battleY : int = 0
	var altitude : int = 0
	
	if side.type == CONST.BATTLE_SIDES.PLAYER:
		
		battleY = activePokemon.battlerPlayerY * 2
	
	elif side.type == CONST.BATTLE_SIDES.ENEMY:
		if sprite.texture.get_height() == 160:
			initial_pos = 0
		elif sprite.texture.get_height() == 190:
			initial_pos = 16
		
		battleY = activePokemon.battlerEnemyY * 2
		altitude = activePokemon.battlerAltitude * 2
		
	sprite.position.y = y_position - initial_pos + battleY - altitude

	
func loadActivePokemon(pokemon:BattlePokemon):
	activePokemon = pokemon
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
	#pokemon.updateBattleInfo()
	#controller.updateActivePokemons()

func removeActivePokemon(pokemon:BattlePokemon):
	pokemon.visible = false
	if pokemon.sideType == CONST.BATTLE_SIDES.PLAYER:
		pass
		#pokemon.reparent($playerBase/Party)
		#pokemon.get_node("Shadow").visible=false
		#pokemon.initPokemonUI($playerBase/HPBarA)
	elif pokemon.sideType == CONST.BATTLE_SIDES.ENEMY:
		#pokemon.reparent($enemyBase/Party)
		pokemon.get_node("Shadow").visible=false
		#pokemon.initPokemonUI($enemyBase/HPBarA)
	#pokemon.updateBattleInfo()
	
func setParticipant(participant:BattleParticipant):
	self.participant = participant
	participant.assignBattleSpot(self)
	
func setSide(_side:BattleSide):
	self.side = _side
	
func swapPokemon(enterPokemon:BattlePokemon):
	quitPokemon()
	enterPokemon(enterPokemon)
	
func enterPokemon(pokemon:BattlePokemon):
	loadActivePokemon(pokemon)
	activePokemon.inBattle = true
	GUI.battle.controller.updateActivePokemonsInfo()
	
func quitPokemon():
	activePokemon.inBattle = false
	activePokemon = null
	#unloadPokemon()
	
