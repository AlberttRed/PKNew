class_name BattleMoveChoice extends BattleChoice

signal moveSelected

var move : BattleMove
var damage : int
var pokemon : BattlePokemon

#func _init(_move : BattleMove, _target : Array[BattlePokemon], _damage : int = 0):
	#move = _move
	#pokemon = _move.pokemon
	#target = _target
	#damage = _damage
	#print(move.Name)
	#priority = _move.priority # La prioritat del movechoice serà la prioritat del moviment
	#type = CONST.BATTLE_ACTIONS.LUCHAR

func _init(pokemon:BattlePokemon):
	#move = _move
	self.pokemon = pokemon
	#target = _target
	#damage = _damage
	#print(move.Name)
	#priority = _move.priority # La prioritat del movechoice serà la prioritat del moviment
	self.type = CONST.BATTLE_ACTIONS.LUCHAR
	if pokemon.controllable:
		GUI.battle.moveSelected.connect(Callable(self, "setMove"))
		GUI.battle.targetSelected.connect(Callable(self, "setTarget"))
	
func selectMove():
	if pokemon.controllable:
		print("nse")
		GUI.battle.showMovesPanel()
		await GUI.battle.moveSelected
		print("uea")
		await move.selectTargets()
		#await GUI.battle.targetSelected
		print("eeee")
		
		#pokemon.actionSelected.emit()
	else:
		print("IA doing move things")
		pokemon.IA.selectMove()
		await move.selectTargets()
		#pokemon.IA.selectTargets()
	moveSelected.emit()

func doMove():
	print(pokemon.Name + " doing move " + move.Name)
	
	await pokemon.applyPreviousEffects()
	
	if pokemon.canAttack:
		#move.target.selectedTargets = target
		await move.use()
	
	await pokemon.applyLaterEffects()
	#pokemon.actionFinished
	
func setMove(_move:BattleMove):
	move = _move
	pokemon.usedMove = _move
	
func setTarget(_target : Array[BattleSpot]):
	target = _target
	
