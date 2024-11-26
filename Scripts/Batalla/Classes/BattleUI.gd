extends Control

class_name BattleUI

signal selectMove
signal changePokemon
signal useBag
signal exitBattle

signal msgClosed
#signal actionSelected
signal moveSelected
signal targetSelected

#@onready var pokeNode : BattlePokemon = $enemyBase/PokemonEnemyA
#@onready var sideNode : BattleSide = $enemyBase

var controller : BattleController = null
@onready var field: BattleField = $Background
@onready var playerField: BattleField = $playerBase
@onready var enemyField: BattleField = $enemyBase

var msgBox : BattleMessageController
#var animController : BattleAnimationList

#var actionSignals : Array[Signal] = [selectMove, changePokemon, useBag, exitBattle]
var actionSignalSelected : Signal

#var pkmnPlayerNodes : Array[Node2D]
#var pkmnEnemyNodes : Array[Node2D]

@onready var cmdLuchar : Panel = $PanelActions/Commands/Luchar
@onready var cmdPokemon : Panel = $PanelActions/Commands/Pokemon
@onready var cmdMochila : Panel = $PanelActions/Commands/Mochila
@onready var cmdHuir : Panel = $PanelActions/Commands/Huir

@onready var pnlMove1 : Panel = $PanelMoves/Moves/Move1
@onready var pnlMove2 : Panel = $PanelMoves/Moves/Move2
@onready var pnlMove3 : Panel = $PanelMoves/Moves/Move3
@onready var pnlMove4 : Panel = $PanelMoves/Moves/Move4

@onready var animController : AnimationPlayer = $AnimationController

var latestMovePanel: Panel = null

#@onready var playerParty : Node2D = $playerBase/PlayerParty
#@onready var enemyParty : Node2D = $enemyBase/EnemyParty

# Called when the node enters the scene tree for the first time.
func _ready():
	#pkmnPlayerNodes.push_back($playerBase/PokemonPlayerA)
	#pkmnPlayerNodes.push_back($playerBase/PokemonPlayerB)
	#pkmnEnemyNodes.push_back($enemyBase/PokemonEnemyA)
	#pkmnEnemyNodes.push_back($enemyBase/PokemonEnemyA)
	set_process_input(false)
	
	

func initUI(_controller):
	controller = _controller
	SignalManager.Battle.Animations.playAnimation.connect(playAnimation)
	#SignalManager.BATTLE.playAnimation.connect(Callable(animController, "playMoveAnimation"))
	#updateUINodes()
	
	#initPartiesUI()
	playerField.position = CONST.BATTLE.PLAYER_BASE_INITIALPOSITION
	enemyField.position = CONST.BATTLE.ENEMY_BASE_INITIALPOSITION
	
	if controller.rules.mode == CONST.BATTLE_MODES.SINGLE:
		initSingleBattleUI()
	elif controller.rules.mode == CONST.BATTLE_MODES.DOUBLE:
		initDoubleBattleUI()
	
	msgBox = BattleMessageController.new()#$PanelMessageBox)
	GUI.setMessageBox($PanelMessageBox)
	#animController = BattleAnimationList.new()
	
	$PanelMessageBox.show()
	$PanelActions.hide()
	$PanelMoves.hide()
	
	set_process_input(true)
	show()
	GUI.resetTransitionScreen()
	return self
	
func clear():
	hide()
	set_process_input(false)
	#msgBox.clear()
	playAnimation("RESET")
	SignalManager.Battle.Animations.playAnimation.disconnect(playAnimation)
	if controller.rules.mode == CONST.BATTLE_MODES.SINGLE:
		clearSingleBattleUI()
	elif controller.rules.mode == CONST.BATTLE_MODES.DOUBLE:
		clearDoubleBattleUI()

#func initSingleBattleUI():
	#$playerBase/PokemonPlayerA.visible = false
	#$enemyBase/PokemonEnemyA.visible = false
	#
	#controller.activePokemons[0].position = CONST.BATTLE.BACK_SINGLE_SPRITE_POS
	#controller.activePokemons[1].position = CONST.BATTLE.FRONT_SINGLE_SPRITE_POS
	#controller.activePokemons[0].get_node("Shadow").visible=false
	#controller.activePokemons[0].reparent($playerBase)
	#controller.activePokemons[1].reparent($enemyBase)
	#controller.activePokemons[0].visible = true
	#controller.activePokemons[1].visible = true
#
	#
	#controller.activePokemons[0].initPokemonUI($playerBase/HPBarA)
	#controller.activePokemons[1].initPokemonUI($enemyBase/HPBarA)
	
func initSingleBattleUI():
	$playerBase/TrainerA.sprite.visible = true
	$playerBase/TrainerA.get_node("Sprite").position = CONST.BATTLE.BACK_SINGLE_TRAINER_POS
	$playerBase/HPBarA.position = CONST.BATTLE.SINGLE_PLAYERHPBAR_A_INITIALPOSITION
	$enemyBase/HPBarA.position = CONST.BATTLE.SINGLE_ENEMYHPBAR_A_INITIALPOSITION
	
	if controller.rules.type == CONST.BATTLE_TYPES.WILD:
		pass
		#$enemyBase/HPBarA.position = CONST.BATTLE.SINGLE_ENEMYHPBAR_FINALPOSITION
	elif controller.rules.type == CONST.BATTLE_TYPES.TRAINER:
		$enemyBase/TrainerA.sprite.visible = true
		$enemyBase/TrainerA.sprite.position = CONST.BATTLE.FRONT_SINGLE_TRAINER_POS
	#playerSide.pokemonSpotA.hide()
	#enemySide.pokemonSpotA.hide()
	#$playerBase/PokemonPlayerA.visible = false
	#$enemyBase/PokemonEnemyA.visible = false
	#loadActivePokemon(controller.activePokemons[0])
	#loadActivePokemon(controller.activePokemons[1])

	
func initDoubleBattleUI():
	$playerBase/PokemonA.position = CONST.BATTLE.BACK_POKEMONA_SPRITE_POS
	$playerBase/PokemonB.visible = true
	$playerBase/PokemonB.position = CONST.BATTLE.BACK_POKEMONB_SPRITE_POS
	
	$enemyBase/PokemonA.position = CONST.BATTLE.FRONT_POKEMONA_SPRITE_POS
	$enemyBase/PokemonB.visible = true
	$enemyBase/PokemonB.position = CONST.BATTLE.FRONT_POKEMONB_SPRITE_POS

func clearSingleBattleUI():
	for s in controller.sides:
		if !s.isDefeated():
			for p:BattleSpot in s.battleSpots:
				p.removeActivePokemon()
		s.clear()

		
func clearDoubleBattleUI():
	pass
	
#func updateUINodes():
	#for i:int in range(controller.sides[0].activePokemons.size()):
		#controller.sides[0].activePokemons[i].battleNode = pkmnPlayerNodes[i]
#
	#for i:int in range(controller.sides[1].activePokemons.size()):
		#controller.sides[1].activePokemons[i].battleNode = pkmnEnemyNodes[i]
##
#
#
#func 	initPartiesUI():
	#for p in controller.playerSide.pokemonParty:
		#p.visible = false
		#playerParty.add_child(p)
		#
	#for p in controller.enemySide.pokemonParty:
		#p.visible = false
		#enemyParty.add_child(p)
		#


func _input(event):
	if event.is_action_pressed("ui_accept"):
		Input.action_release("ui_accept")
		#controller.active_pokemon.doAnimation()
		INPUT.ui_accept.free_state()
		if onConfirmationPanel():
			print("Confirmation selected")
		elif onActionsPanel():
				print("Action selected")
				actionSignalSelected.emit()
		elif onMovesPanel():
				print("Move selected")
				if controller.active_pokemon.selected_move.pp_actual == 0:
					await GUI.battle.showMessage("¡No quedan PP para este movimiento!", false, 2.0)
					selectMove.emit(true)
				else:
					moveSelected.emit(controller.active_pokemon.selected_move)
	elif event.is_action_pressed("ui_cancel"):
		if onMovesPanel():
			hideMovesPanel()
			cmdLuchar.grab_focus()
			
func setPanelActionsText(text:String):
	$PanelActions/Label.text = text
	$PanelActions/Label/Label2.text = text
			
func showMessageWait(text:String, waitTime:float):#, showIcon : bool = true, _waitTime : float = 0.0, waitInput:bool = false):
	showPanel($PanelMessageBox)
	await GUI.showMessageWait(text, waitTime)

func showMessageNoClose(text:String):#, showIcon : bool = true, _waitTime : float = 0.0, waitInput:bool = false):
	showPanel($PanelMessageBox)
	await GUI.showMessageNoClose(text)

func showMessageInput(text:String):
	showPanel($PanelMessageBox)
	await GUI.showMessageInput(text)

func showMessageYesNo(text:String):
	showPanel($PanelMessageBox)
	return await GUI.showMessageYesNo(text)
	
func showActionsPanel():
	setPanelActionsText("¿Qué debería hacer \n" + controller.active_pokemon.Name + "?")
	cmdLuchar.grab_focus()
	showPanel($PanelActions)
	
func showMovesPanel(rememberFocus = false):
	showPanel($PanelMoves)
	initMovesPanel()
	if rememberFocus:
		latestMovePanel.grab_focus()
	else:
		pnlMove1.grab_focus()
		#
#func showConfirmationPanel():
	#var array:Array[String] = ["SI","NO"]
	#$ChoicesContainer.activeChoices(array)
	#$ChoicesContainer.showContainer()
	#
#func showParty():
	#GUI.show_party(CONST.PARTY_MODES.BATTLE)
	#await GUI.party.exit
	#cmdPokemon.grab_focus()
	
func showParty() -> BattlePokemon: #Modificarem el showParty dle BattleUI, enlloc de ferho en el GUI
	var selectedPokemon:BattlePokemon
	await GUI.fadeIn(3)
	GUI.party.open(CONST.PARTY_MODES.BATTLE)
	await GUI.party.exit
	await GUI.fadeOut(3)
	return GUI.party.selectedBattlePokemon

func hideMovesPanel():
	showPanel($PanelActions)
	initMovesPanel()
	pnlMove1.release_focus()
	pnlMove2.release_focus()
	pnlMove3.release_focus()
	pnlMove4.release_focus()
	
func initMovesPanel():
	var panels = $PanelMoves/Moves.get_children()
	var i = 0
	
	clearMovePanel(pnlMove1)
	clearMovePanel(pnlMove2)
	clearMovePanel(pnlMove3)
	clearMovePanel(pnlMove4)

	for m in controller.active_pokemon.moves:
		panels[i].visible = true
		panels[i].get_node("Label").text = m.Name
		panels[i].get("theme_override_styles/panel").region_rect.position.y = (46 * (m.type.id-1))
		i += 1
		
	if controller.active_pokemon.moves.size() >= 2:
		pnlMove1.set_focus_neighbor(SIDE_RIGHT, "../Move2")
		pnlMove2.set_focus_neighbor(SIDE_LEFT, "../Move1")
	if controller.active_pokemon.moves.size() >= 3:
		pnlMove1.set_focus_neighbor(SIDE_BOTTOM, "../Move3")
		pnlMove3.set_focus_neighbor(SIDE_TOP, "../Move1")
	if controller.active_pokemon.moves.size() == 4:
		pnlMove3.set_focus_neighbor(SIDE_RIGHT, "../Move4")
		pnlMove2.set_focus_neighbor(SIDE_BOTTOM, "../Move4")
		pnlMove4.set_focus_neighbor(SIDE_TOP, "../Move2")
		pnlMove4.set_focus_neighbor(SIDE_LEFT, "../Move3")
			
func _on_action_focus_entered():
	print("lol")
	if cmdLuchar.has_focus():
		print("Luchar!")
		cmdLuchar.get("theme_override_styles/panel").region_rect.position.x = 130
		#controller.active_pokemon.selected_action = CONST.BATTLE_ACTIONS.LUCHAR
		actionSignalSelected = selectMove
	elif cmdPokemon.has_focus():
		print("Pokemon!")
		cmdPokemon.get("theme_override_styles/panel").region_rect.position.x = 130
		#controller.active_pokemon.selected_action = CONST.BATTLE_ACTIONS.POKEMON
		actionSignalSelected = changePokemon
	elif cmdMochila.has_focus():
		print("Mochila!")
		cmdMochila.get("theme_override_styles/panel").region_rect.position.x = 130
		#controller.active_pokemon.selected_action = CONST.BATTLE_ACTIONS.MOCHILA
		actionSignalSelected = useBag
	elif cmdHuir.has_focus():
		print("Huir!")
		cmdHuir.get("theme_override_styles/panel").region_rect.position.x = 130
		#controller.active_pokemon.selected_action = CONST.BATTLE_ACTIONS.HUIR
		actionSignalSelected = exitBattle

func _on_action_focus_exited():
	#if controller.active_pokemon.controllable:
		#controller.active_pokemon.selected_action = null
	cmdLuchar.get("theme_override_styles/panel").region_rect.position.x = 0
	cmdPokemon.get("theme_override_styles/panel").region_rect.position.x = 0
	cmdMochila.get("theme_override_styles/panel").region_rect.position.x = 0
	cmdHuir.get("theme_override_styles/panel").region_rect.position.x = 0


func _on_move_focus_entered():
	var move : BattleMove = null
	if pnlMove1.has_focus():
		latestMovePanel = pnlMove1
		move = controller.active_pokemon.moves[0]
		print(move.Name)
		pnlMove1.get("theme_override_styles/panel").region_rect.position.x = 192
		controller.active_pokemon.selected_move = move

	elif pnlMove2.has_focus():
		latestMovePanel = pnlMove2
		move = controller.active_pokemon.moves[1]
		print(move.Name)
		pnlMove2.get("theme_override_styles/panel").region_rect.position.x = 192
		controller.active_pokemon.selected_move = move

	elif pnlMove3.has_focus():
		latestMovePanel = pnlMove3
		move = controller.active_pokemon.moves[2]
		print(move.Name)
		pnlMove3.get("theme_override_styles/panel").region_rect.position.x = 192
		controller.active_pokemon.selected_move = move
		
	elif pnlMove4.has_focus():
		latestMovePanel = pnlMove4
		move = controller.active_pokemon.moves[3]
		print(move.Name)
		pnlMove4.get("theme_override_styles/panel").region_rect.position.x = 192
		controller.active_pokemon.selected_move = move

	updateMoveInfoPanel(move)
	
		

func updateMoveInfoPanel(move:BattleMove):
	if move != null:
		$PanelMoves/MoveType.vframes = 1
		$PanelMoves/MoveType.texture = move.type.image
		$PanelMoves/lblPPs.text = "PP: " + str(move.pp_actual) + "/" + str(move.pp_total)
		
		if move.pp_actual == 0:
			$PanelMoves/lblPPs.add_theme_color_override("font_color", Color("FF4A4A"))
			$PanelMoves/lblPPs.add_theme_color_override("font_shadow_color", Color("8C3131"))
		elif move.pp_actual > 0 && float(move.pp_actual) <= move.pp_total/4.0:
			$PanelMoves/lblPPs.add_theme_color_override("font_color", Color("FF8C21"))
			$PanelMoves/lblPPs.add_theme_color_override("font_shadow_color", Color("944A18"))
		elif float(move.pp_actual) > move.pp_total/4.0 && float(move.pp_actual) <= move.pp_total/2.0:
			$PanelMoves/lblPPs.add_theme_color_override("font_color", Color("FFC600"))
			$PanelMoves/lblPPs.add_theme_color_override("font_shadow_color", Color("946B00"))
		else:
			$PanelMoves/lblPPs.remove_theme_color_override("font_color")
			$PanelMoves/lblPPs.remove_theme_color_override("font_shadow_color")

	
	
func showTargetSelection():
	#funció que farà seleccionar el target al Player. 
	#controller.active_pokemon.selected_action.target = controller.active_pokemon.listEnemies
	#var listBattleSpots:Array[BattleSpot]
	#for e in controller.active_pokemon.listEnemies:
		#listBattleSpots.push_back(e.battleSpot)
	SignalManager.Battle.selectTarget.emit(controller.active_pokemon.listEnemies[0])


func _on_move_focus_exited():
	controller.active_pokemon.selected_move = null
	pnlMove1.get("theme_override_styles/panel").region_rect.position.x = 0
	pnlMove2.get("theme_override_styles/panel").region_rect.position.x = 0
	pnlMove3.get("theme_override_styles/panel").region_rect.position.x = 0
	pnlMove4.get("theme_override_styles/panel").region_rect.position.x = 0

func clearMovePanel(pnl : Panel):
	pnl.visible = false
	pnl.focus_neighbor_top = ""
	pnl.focus_neighbor_left = ""
	pnl.focus_neighbor_right = ""
	pnl.focus_neighbor_bottom = ""

func onMovesPanel():
	return $PanelMoves.visible and !$PanelMessageBox.visible and !$PanelActions.visible and !GUI.party.visible #and controller.active_pokemon.selected_move != null
	
func onActionsPanel():
	return $PanelActions.visible and !$PanelMessageBox.visible and !$PanelMoves.visible and !GUI.party.visible #and controller.active_pokemon.selected_action != -1

func onConfirmationPanel():
	return $ChoicesContainer.visible

func showPanel(_panel : Panel):
	$PanelMessageBox.hide()
	$PanelActions.hide()
	$PanelMoves.hide()
	
	_panel.show()
	
func showHPBarUI(hpBar:HPBar):
	var side:CONST.BATTLE_SIDES = hpBar.get_parent().side.type#pokemon.battleSpot.side.type
	await playAnimation("SHOW_HPBAR",{'Side':side},hpBar)

func hideHPBarUI(hpBar:HPBar):
	var side:CONST.BATTLE_SIDES = hpBar.get_parent().side.type#hpBar.pokemon.battleSpot.side.type
	await playAnimation("HIDE_HPBAR",{'Side':side},hpBar)

func playAnimation(animation, animParams:Dictionary = {}, _root:Node = self):
	#if _root != null:
		#var rootNode:NodePath = animPlayer.get_path_to(_root)
		#animPlayer.root_node = rootNode
	#animController.root = _root
	await animController.playAnimation(animation, animParams, _root)
	
func stopAnimation(animation:String):
	animController.stopAnimation(animation)
