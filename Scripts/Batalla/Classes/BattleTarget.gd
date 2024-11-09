class_name BattleTarget

enum TYPE {
	NONE,
	ESPECIFICO, # El Target es selecciona automáticament segons el moviment, son casos especials. Ex: Maldición, Contraataque En cas de combat doble, no fa seleccionar res
	YO_PRIMERO, # Cas especial per l atac Yo Primero. Es selecciona el pokemon individualment, com un atac normal.
	ALIADO, # L atac va dirigit per força l aliat del pokemon que executa l atac. Si no té aliat l'atac fallarà. Ex: Refuerzo En cas de combat doble, no fa seleccionar res
	BASE_PLAYER, # Efecta a la BASE/FIELD. L'atac afecta a tots els pkmn q estàn a la mateixa base que el pkmn atacant. El target serà el mateix pokemon atacant i el seu aliat. Ex: Pantalla Luz En cas de combat doble, no fa seleccionar res
	USER_OR_ALLY, # El jugador podrà seleccionar l'objectiu entre el propi pokemon atacant i l'aliat. Només un dels dos. En cas de combat doble, fa seleccionar entre el pokemon i l'aliat. En els enemics no deixa.
	BASE_ENEMY, # Efecta a la BASE/FIELD. A la inversa que el BASE_PLAYER, l atac afectarà a TOTS els pokemons q estiguin la base rival. Ex: Púas En cas de combat doble, no fa seleccionar res
	USER, #Efecte a l'usuari. Només es pot seleccionar el pokemon que fa l'atac. Ex: Danza espada En cas de combat doble, no fa seleccionar res
	RANDOM_ENEMY, #Efecte a un dels dos pokemons enemics aleatoriament. No pots seleccionar quin. Ex: Combate En cas de combat doble, no fa seleccionar res
	ALL_OTHER, #L'atac efecte a tots els pokemons sobre el camp de batalla menys l'atacant. Inclós els aliats. Ex: Surf. En cas de combat doble, no fa seleccionar res
	SELECCIONAR, #El jugador selecciona individualment un pokemon, com qualsevol atac normal. Ex: Placaje #El jugador selecciona individualment un pokemon, com qualsevol atac normal. Ex: Placaje  En cas de combat doble, pot seleccionar els dos enemics i l'aliat. Si només queda un enemic (aliat i altre enemic morts), tambe et fa seleccioanr igualment, encara q nomes en qeu
	ENEMIES, #L'atac afecta a tots els pokemons rivals. Ex: Malicioso  En cas de combat doble, no fa seleccionar res
	ALL_FIELD, # Afecta al FIELD. Afecta al camp de batalla, per tant a tots els pokemons en combat, inclós l'atacant. Exemple: Tormenta Arena, Danza lluvia..  En cas de combat doble, no fa seleccionar res
	PLAYERS, # Al revés que ENEMIES, afecta directament al pokemon atacant i aliats, pero no als enemics. Ex: Campana Cura  En cas de combat doble, no fa seleccionar res
	ALL_POKEMON # Afecta directament a tots els pokemons en combat. Ex: Canto Mortal  En cas de combat doble, no fa seleccionar res
}

var type : TYPE:
	get:
		return move.target_type
var move : BattleMove
var controllable:bool:
	get:
		return move.pokemon.controllable
var selectedTargets: Array
var actualTarget:
	get:
		if selectedTargets == null or selectedTargets.is_empty() or _targetCursor > selectedTargets.size()-1:
			return null	
		return selectedTargets[_targetCursor]
var _targetCursor : int = -1 #Cursos que indica el target actual (actualTarget). Cada vegada que es llança el nextTarget, avança en una posició.

func _init(move:BattleMove) -> void:
	self.move = move

func selectTargets():
	SignalManager.Battle.selectTarget.connect(addTarget)
	match type:
		TYPE.ESPECIFICO:
			pass # TO DO
		TYPE.YO_PRIMERO:
			pass # TO DO
		TYPE.ALIADO:
			doTargetAliado()
		TYPE.BASE_PLAYER:
			doTargetBasePlayer()
		TYPE.USER_OR_ALLY:
			doTargetUserOrALly()
		TYPE.BASE_ENEMY:
			doTargetBaseEnemy()
		TYPE.USER:
			doTargetUser()
		TYPE.RANDOM_ENEMY:
			doTargetRandomEnemy()
		TYPE.ALL_OTHER:
			doTargetAllOther()
		TYPE.SELECCIONAR:
			doTargetSeleccionar()
		TYPE.ENEMIES:
			doTargetEnemies()
		TYPE.ALL_FIELD:
			doTargetAllField()
		TYPE.PLAYERS:
			doTargetPlayers()
		TYPE.ALL_POKEMON:
			doTargetAllPokemon()
	SignalManager.Battle.selectTarget.disconnect(addTarget)
	
func addTarget(target):
	selectedTargets.push_back(target)
	if move.effect != null:
		move.effect.setTarget(target)
	SignalManager.Battle.targetSelected.emit()
	
func nextTarget() ->bool:
	_targetCursor+=1
	return actualTarget!=null

func doTargetAliado():
	for ally:BattlePokemon in move.pokemon.listAllies:
		addTarget(ally.battleSpot)

func doTargetBasePlayer():
	addTarget(move.pokemon.side.field)
	
func doTargetUserOrALly():
	if GUI.battle.controller.rules.mode == CONST.BATTLE_MODES.SINGLE:
		doTargetUser()
		return
		
	GUI.battle.showTargetSelection() #Podria fer dos funcions, showtargetselectionAll, showtargetselectionAlly
	await SignalManager.BATTLE.targetSelected
	
func doTargetBaseEnemy():
	addTarget(move.pokemon.opponentSide.field)
	
func doTargetUser():
	addTarget(move.pokemon.battleSpot)

func doTargetRandomEnemy():
	randomize()
	var i:int = randi_range(1, move.pokemon.opponentSide.activePokemons.size()) - 1
	addTarget(move.pokemon.opponentSide.activePokemons[i].battleSpot)

func doTargetAllOther():
	doTargetAliado()
	doTargetEnemies()

func doTargetSeleccionar():
	if GUI.battle.controller.rules.mode == CONST.BATTLE_MODES.SINGLE:
		addTarget(move.pokemon.listEnemies[0].battleSpot)
		return
	if controllable:
		GUI.battle.showTargetSelection()
		await SignalManager.BATTLE.targetSelected
	else:
		move.pokemon.IA.selectTargets()

func doTargetEnemies():
	for enemy:BattleSpot in move.pokemon.opponentSide.battleSpots:
		addTarget(enemy)

func doTargetAllField():
	doTargetBasePlayer()
	doTargetBaseEnemy()
	
func doTargetPlayers():
	for player:BattleSpot in move.pokemon.side.battleSpots:
		addTarget(player)

func doTargetAllPokemon():
	doTargetEnemies()
	doTargetPlayers()
	
func clear():
	_targetCursor = -1
	selectedTargets.clear()
