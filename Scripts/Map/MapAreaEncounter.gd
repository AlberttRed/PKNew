extends Node

var p = load("res://Scripts/Map/MapPokemonEncounter.gd")

@export var encounterArea : AreaEncounter
@export var pokemonEncounterList : Array[MapPokemonEncounter]

var selected_pokemon
var selected_level : int
# Called when the node enters the scene tree for the first time.
func _ready():
	checkTotalProbability()


func checkTotalProbability():
	var total = 0
	for pk in pokemonEncounterList:
		total += pk.probability
	
	if total != 100.0:
		push_error("El % total de l'area " + str(name) + " no suma 100")

#Funció que calcula aleatoriament si apareix un pokemon salvatge o no.
#Basat més o menys amb com ho fa en els jocs oficials 
func tryEncounter():
	var area_chance : float = float(encounterArea.EncounterChance)
	const initial_multiplier : float = 16.0 # El joc original ho multiplica per aquest valor
	var chance : float = 0.0
	var rand_value = randf_range(0, 2880)
	
	chance = area_chance * initial_multiplier
	
	#Aqui es faràn els modificadors (si va en bici, si corra, si fa servir x objecte)
	
	if chance > rand_value:
		return true
	return false

func getPokemonEncounter():
	selected_pokemon = getPokemon()
	selected_level = getLevel()

	var pkmn = PokemonInstance.new().create(true, selected_pokemon.pkmn_id, selected_level)
	pkmn.isWild = true
	print("A wild " + str(pkmn.Name) + " Lvl. " + str(pkmn.level) + " appeared!")
	
	var enemyBattler : Battler = Battler.new().create(CONST.BATTLER_TYPES.WILD_POKEMON, [pkmn], BattleIA_Wild.new())
	
	var br : BattleRules = BattleRules.new(CONST.BATTLE_TYPES.WILD, CONST.BATTLE_MODES.SINGLE)	
	var bc : BattleController = BattleController.new(br)
	#var bs_player : BattleSide = BattleSide.new(CONST.BATTLE_SIDES.PLAYER)
	#var bs_enemy : BattleSide = BattleSide.new(CONST.BATTLE_SIDES.ENEMY)
	
	bc.playerSide.addParticipant(GLOBAL.PLAYER.trainer, true)
	bc.enemySide.addParticipant(enemyBattler, false)
	
	bc.playerSide.initSide(br)
	bc.enemySide.initSide(br)
	
	await bc.initBattle()
	

func getPokemon():
	randomize()
	var valor : float = randf() # Em dona un valor entre 0 i 100
	var chance : float = 0
	
	for pk in pokemonEncounterList:
		chance += pk.probability / 100.0 # Ho dividim per 100 per obtenir la probabilitat entre 0 i 100
	
		if valor <= chance:
			return pk
			
	push_error("getPokemon() could not get pokemon")
	return null

func getLevel():
	randomize()
	return randi_range(selected_pokemon.min_level, selected_pokemon.max_level)
