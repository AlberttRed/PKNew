extends Control

class_name PartySummary

signal closed

enum {
DATA,
TRAINER,
STATS,
MOVES,
RIBBONS
}

var loadedParty:Array[PokemonInstance]
var pages:Array[Panel]
@onready var generalInfo:Control = $GENERAL
var activePage:Panel:
	get:
		return pages[summaryIndex]

var summaryIndex = 0 #Index used to move between summaries pages
var movingIndex: int = 0 #Index used to move between pokemon summaries

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generalInfo.hide()
	visibility_changed.connect(onVisibilityChanged)
	for c:Panel in $PAGES.get_children():
		c.hide()
		pages.push_back(c)
	pages[MOVES].showGeneralInfo.connect(showGeneralInfo)
	

func showSummary(page:int) -> void:
	show()
	generalInfo.show()
	pages[page].open()

	
func loadPokemonInfo(pokemon:PokemonInstance):
	loadGeneralInfo(pokemon)
	for page:Panel in pages:
		page.loadPokemonInfo(pokemon)

func loadGeneralInfo(pokemon:PokemonInstance):
	generalInfo.get_node("Nombre").text = pokemon.Name
	generalInfo.get_node("Nombre/Outline").text = pokemon.Name
	
	if pokemon.gender == CONST.GENEROS.MACHO:
		generalInfo.get_node("Genero").texture = load("res://Escenas/UI/Menus/Resources/male_icon.png")
	elif pokemon.gender == CONST.GENEROS.HEMBRA:
		generalInfo.get_node("Genero").texture = load("res://Escenas/UI/Menus/Resources/female_icon.png")
	else:
		generalInfo.get_node("Genero").texture = null

	if pokemon.fainted:
		generalInfo.get_node("Status").visible = true
		generalInfo.get_node("Status").region_enabled = false
		generalInfo.get_node("Status").region_rect = Rect2(0, 16*(CONST.STATUS.FAINTED-1), 44, 16)
	else:
		if pokemon.status != CONST.STATUS.OK:
			generalInfo.get_node("Status").region_enabled = true
			generalInfo.get_node("Status").visible = true
			generalInfo.get_node("Status").region_rect = Rect2(0, 16*(pokemon.status-1), 44, 16)
		else:
			generalInfo.get_node("Status").visible = false
	#--- falta pokeball
	#--- falta objecte
	#--- falta barra exp
	generalInfo.get_node("Nivel").text = str(pokemon.level)
	generalInfo.get_node("Nivel/Outline").text = str(pokemon.level)
	generalInfo.get_node("Sprite").texture = pokemon.battle_front_sprite#load("res://Sprites/Batalla/Battlers/" + str(pokemon.pkm_id).pad_zeros(3) + ".png")
	
func closeSummary(page:int):
	pages[page].hide()

func close():
	summaryIndex = 0
	await GUI.fadeIn(3)
	self.hide()
	for page:Panel in pages:
		page.hide()
	closed.emit()
	
func showGeneralInfo(_visible:bool):
	generalInfo.visible = _visible

#region GUI ACTIONS

func selectOption():
	pass
	
func cancelOption():
	if activePage.name == "MOVES" and activePage.mode != activePage.Modes.NORMAL:
		return
	close()
	
func moveLeft():
	if activePage.name == "MOVES" and activePage.mode != activePage.Modes.NORMAL:
		return
	if visible and summaryIndex > 0:
		summaryIndex -= 1
		pages[summaryIndex].open()
		pages[summaryIndex+1].hide()
	
func moveRight():
	print(activePage.name)
	if activePage.name == "MOVES":
		print(activePage.mode)
	if activePage.name == "MOVES" and activePage.mode != activePage.Modes.NORMAL:
		return
	if visible and summaryIndex < 4:
		summaryIndex += 1
		pages[summaryIndex].open()
		pages[summaryIndex-1].hide()

func moveUp():
	if activePage.name == "MOVES" and activePage.mode != activePage.Modes.NORMAL:
		return
	if visible and movingIndex > 0:
		movingIndex -= 1
		loadPokemonInfo(loadedParty[movingIndex])
	
func moveDown():
	if activePage.name == "MOVES" and activePage.mode != activePage.Modes.NORMAL:
		return
	if movingIndex < 5:
		movingIndex += 1
		loadPokemonInfo(loadedParty[movingIndex])
	
func onVisibilityChanged():

	if self.visible:
		GUI.accept.connect(selectOption)
		GUI.cancel.connect(cancelOption)
		GUI.left.connect(moveLeft)
		GUI.right.connect(moveRight)
		GUI.up.connect(moveUp)
		GUI.down.connect(moveDown)
	else:
		GUI.accept.disconnect(selectOption)
		GUI.cancel.disconnect(cancelOption)
		GUI.left.disconnect(moveLeft)
		GUI.right.disconnect(moveRight)
		GUI.up.disconnect(moveUp)
		GUI.down.disconnect(moveDown)
	
#endregion
