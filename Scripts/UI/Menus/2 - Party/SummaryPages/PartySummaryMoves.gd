extends Panel

signal moveSelected
signal showGeneralInfo

enum Modes {
	NORMAL,
	DETAILED,
	LEARNING
}

const MOVEPANELS_DEFAULT_POSITION = Vector2(240, 92)
const MOVEPANELS_LEARNING_POSITION = Vector2(240, 16)

@export var normalBackground:Texture
@export var detailedBackground:Texture
@export var learningBackground:Texture
@export var moveSelMark:Texture

@onready var movePanels:Array[Panel] = [$MovePanels/Move1,$MovePanels/Move2,$MovePanels/Move3,$MovePanels/Move4]
@onready var mode:Modes = Modes.NORMAL: set = setMode
@onready var moveInfo:Control = $MoveInfo
@onready var learningMovePanel = $Move0

var moveIndexSelected
var activePanel:Panel

var learningMove:MoveInstance:
	set(m):
		learningMove = m
var pokemon:PokemonInstance
var moves:Array[MoveInstance]
var originMoveIndexSelected = null
var targetMoveIndexSelected = null

var moveIndex:int:
	get:
		if activePanel == null:
			return -1
		else:
			return int(activePanel.name.right(1))-1

var activeMove:MoveInstance:
	get:
		if moveIndex == -1:
				return learningMove
		return moves[moveIndex]

func _ready() -> void:
	setLearningPanel(false)

func open(learningMode:bool = false):
	get_viewport().gui_focus_changed.connect(onFocusChanged)
	GUI.accept.connect(selectOption)
	GUI.cancel.connect(cancelOption)
	if learningMode:
		self.mode = Modes.LEARNING
	else:
		self.mode = Modes.NORMAL
	show()
	if mode == Modes.LEARNING:
		await GUI.fadeOut(3)
		await moveSelected
	return moveIndexSelected
		

func loadPokemonInfo(pokemon:PokemonInstance):
	clear()
	self.pokemon = pokemon
	self.moves = pokemon.movements
	loadMoves()
		
func loadMoves():
	for i in range(moves.size()):
		loadMove(movePanels[i], moves[i])

func loadMove(movePanel:Panel, move:MoveInstance):
	movePanel.visible = true
	movePanel.get_node("Ataque").setText(move.Name)
	movePanel.get_node("Tipo").frame = move.type.id
	movePanel.get_node("dPP").setText(str(move.pp_actual) + "/" + str(move.pp))
	movePanel.focus_mode = Control.FOCUS_ALL
	movePanel.get_theme_stylebox("panel").set("texture", null)

func loadMoveInfo(move:MoveInstance):
	moveInfo.get_node("Sprite").texture = pokemon.icon_sprite
	moveInfo.get_node("Type1").texture = pokemon.type_a.image
	moveInfo.get_node("Type1").vframes = 1
	if  pokemon.type_b != null:
		moveInfo.get_node("Type2").visible = true
		moveInfo.get_node("Type2").texture = pokemon.type_b.image
		moveInfo.get_node("Type2").vframes = 1
	else:
		moveInfo.get_node("Type2").visible = false
	match move.damage_class:
		CONST.DAMAGE_CLASS.FISICO:
			moveInfo.get_node("dCategory").frame = 0
		CONST.DAMAGE_CLASS.ESPECIAL:
			moveInfo.get_node("dCategory").frame = 1
		CONST.DAMAGE_CLASS.ESTADO:
			moveInfo.get_node("dCategory").frame = 2
	if move.power != 0:
		moveInfo.get_node("dPower").setText(move.power)
	else:
		moveInfo.get_node("dPower").setText("---")
	if move.accuracy != 0:
		moveInfo.get_node("dAccuracy").setText(move.accuracy)
	else:
		moveInfo.get_node("dAccuracy").setText("---")
	moveInfo.get_node("lDescription").setText(move.description)
	
func clear():
	moves = []
	for panel:Panel in movePanels:
		panel.visible = false
		panel.get_node("Ataque").text = ""
		panel.get_node("Ataque/Outline").text = ""
		panel.get_node("Tipo").frame = 0
		panel.get_node("dPP").text = ""
		panel.get_node("dPP/Outline").text = ""

func setMode(_mode:Modes):
	mode = _mode
	match _mode:
		Modes.NORMAL:
			setNormalMode()
		Modes.DETAILED:
			setDetailedMode()
		Modes.LEARNING:
			setLearningMode()
			
func select(_panel:Panel=null):
	var panel:Panel
	if _panel!=null:
		panel = _panel
	else:
		panel = activePanel
	panel.z_index = 1
	panel.get_theme_stylebox("panel").set("texture", moveSelMark)
	if moveIndex != originMoveIndexSelected:
		panel.get_theme_stylebox("panel").set("region_rect", Rect2(0, 0, 252, 74))
	loadMoveInfo(activeMove)
	
func unselect(_panel:Panel=null):
	var panel:Panel
	if _panel!=null:
		panel = _panel
	else:
		panel = activePanel
	panel.z_index = 0
	if moveIndex != originMoveIndexSelected:
		panel.get_theme_stylebox("panel").set("texture", null)

func selectOption():
	if mode == Modes.NORMAL:#activePanel == null:
		setMode(Modes.DETAILED)
		movePanels[0].grab_focus()
	elif mode == Modes.DETAILED:
		if originMoveIndexSelected == null:
			originMoveIndexSelected = moveIndex
			setSelectedPanel()
		else:
			if moveIndex != originMoveIndexSelected:
				targetMoveIndexSelected = moveIndex
				swapMoves(moves[originMoveIndexSelected], moves[targetMoveIndexSelected])
				select()
	elif mode == Modes.LEARNING:
		if moveIndex != -1:
			moveIndexSelected = moveIndex
		moveSelected.emit()

func cancelOption():
	if mode == Modes.DETAILED:#if activePanel != null:
		activePanel.release_focus()
		setMode(Modes.NORMAL)
		if originMoveIndexSelected != null:
			unselect(movePanels[originMoveIndexSelected])
			originMoveIndexSelected = null
	elif mode == Modes.LEARNING:
		moveSelected.emit()

func swapMoves(originMove:MoveInstance, targetMove:MoveInstance):
	moves[targetMoveIndexSelected] = originMove
	moves[originMoveIndexSelected] = targetMove
	loadMoves()
	targetMoveIndexSelected = null
	originMove = null
	targetMove = null
	unselect(movePanels[originMoveIndexSelected])
	originMoveIndexSelected = null
	unselect()

func _on_move_focus_entered() -> void:
	if activePanel != null:
		select()


func _on_move_focus_exited() -> void:
	if activePanel != null:
		unselect()
	activePanel = null

func _on_hidden() -> void:
	activePanel = null
	get_viewport().gui_focus_changed.disconnect(onFocusChanged)
	GUI.accept.disconnect(selectOption)
	GUI.cancel.disconnect(cancelOption)

func onFocusChanged(control:Control):
	self.activePanel=control
	
func setSelectedPanel():
	activePanel.get_theme_stylebox("panel").set("region_rect", Rect2(0, 74, 252, 74))

func setNormalMode():
	setLearningPanel(false)
	get_theme_stylebox("panel").texture = normalBackground
	showGeneralInfo.emit(true)
	$MovePanels.position = MOVEPANELS_DEFAULT_POSITION
	moveInfo.hide()
	
func setDetailedMode():
	setLearningPanel(false)
	get_theme_stylebox("panel").texture = detailedBackground
	showGeneralInfo.emit(false)
	$MovePanels.position = MOVEPANELS_DEFAULT_POSITION
	moveInfo.show()
	
func setLearningMode():
	get_theme_stylebox("panel").texture = learningBackground
	showGeneralInfo.emit(false)
	setLearningPanel(true)
	$MovePanels.position = MOVEPANELS_LEARNING_POSITION
	moveInfo.show()
	movePanels[0].grab_focus()
	
func setLearningPanel(active:bool):
	learningMovePanel.visible = active
	if active:
		loadMove(learningMovePanel, learningMove)
	else:
		learningMovePanel.focus_mode = FOCUS_NONE
