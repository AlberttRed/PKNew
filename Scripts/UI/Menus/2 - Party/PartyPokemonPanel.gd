extends Panel
class_name PartyPokemonPanel

signal selected
signal swappedOut
signal swappedIn

@export var style_rounded_normal : StyleBox
@export var style_rounded_normal_sel : StyleBox
@export var style_rounded_fainted : StyleBox
@export var style_rounded_fainted_sel : StyleBox
@export var style_rounded_swap : StyleBox
@export var style_rounded_swap_sel : StyleBox

@export var style_square_normal : StyleBox
@export var style_square_normal_sel : StyleBox
@export var style_square_empty : StyleBox
@export var style_square_fainted : StyleBox
@export var style_square_fainted_sel : StyleBox
@export var style_square_swap : StyleBox
@export var style_square_swap_sel : StyleBox

var mode:Party.Modes = Party.Modes.MENU
var order:int #Panel order inside Party
var pokemon:PokemonInstance
var swapping:bool = false

func _ready() -> void:
	self.focus_mode = Control.FOCUS_NONE
	self.visible = false

func loadPokemon(pokemon:PokemonInstance):
	self.visible = true
	self.pokemon = pokemon
	focus_mode = FocusMode.FOCUS_ALL
	
	$Nombre.text = pokemon.Name
	$Nombre/Outline.text = pokemon.Name
	
	$Nivel.text = "Nv." + str(pokemon.level)
	$Nivel/Outline.text = "Nv." + str(pokemon.level)
	
	
	if pokemon.fainted:
		$Status.visible = true
		$Status.region_enabled = true
		$Status.region_rect = Rect2(0, 16*(CONST.STATUS.FAINTED-1), 44, 16)
	else:
		if pokemon.status != CONST.STATUS.OK:
			$Status.region_enabled = true
			$Status.visible = true
			$Status.region_rect = Rect2(0, 16*(pokemon.status-1), 44, 16)
		else:
			$Status.visible = false

	$health_bar.init(pokemon)
	
	$pkmn.texture = load("res://Resources/Pokemon/" + str(pokemon.pkm_id).pad_zeros(3) + ".tres").icon_sprite
	
	var percentage:float = float(pokemon.hp_actual) / float(pokemon.hp_total)
	print(percentage)
	#$health_bar/health.scale = Vector2(percentage, 1)
	
	if pokemon.gender == CONST.GENEROS.MACHO:
		$gender.texture = load("res://Escenas/UI/Menus/Resources/male_icon.png")
	elif pokemon.gender == CONST.GENEROS.HEMBRA:
		$gender.texture = load("res://Escenas/UI/Menus/Resources/female_icon.png")
	else:
		$gender.texture = null
	#unselect()

func select():
	var form = ""
	var type = ""
	
	if order == 0:
		form = "rounded"
	else:
		form = "square"
		
	if pokemon.fainted:
		type = "fainted_sel"
	elif mode == Party.Modes.MENU:
		type = "normal_sel"
	elif mode == Party.Modes.SWAP:
		if swapping:
			type = "swap"
		else:
			type = "swap_sel"
		
	add_theme_stylebox_override("panel", get("style_" + form + "_" + type))
	$ball.texture = load("res://Escenas/UI/Menus/Resources/partyBallSel.PNG")
	$AnimationPlayer.play("party_animations/PARTY_pkmn_icon_updown")
	
	selected.emit(order)
	
func setSwapMode():
	self.mode = Party.Modes.SWAP

func unselect():
	var form = ""
	var type = ""
	
	if order == 0:
		form = "rounded"
	else:
		form = "square"
	if pokemon.fainted:
		type = "fainted"
	elif mode != Party.Modes.SWAP or (mode == Party.Modes.SWAP && !swapping):
		type = "normal"
	elif mode == Party.Modes.SWAP && swapping:
		type = "swap"
	add_theme_stylebox_override("panel", get("style_" + form + "_" + type))
	$ball.texture = load("res://Escenas/UI/Menus/Resources/partyBall.PNG")
	$AnimationPlayer.play("party_animations/PARTY_pkmn_icon")
	
func update_styles():
	var form = ""
	var type = ""
	
	if order == 0:
		form = "rounded"
	else:
		form = "square"
		
func clear():
	unselect()
	self.order = 0
	self.pokemon = null
	SignalManager.disconnectAll(selected)
	self.swapping = false
	self.mode = Party.Modes.MENU


func _on_focus_entered() -> void:
	if !GUI.isFading():
		select()


func _on_focus_exited() -> void:
	if !GUI.isFading():
		unselect()

func enableFocus():
	if !focus_entered.is_connected(_on_focus_entered):
		focus_entered.connect(_on_focus_entered)
	if !focus_exited.is_connected(_on_focus_exited):
		focus_exited.connect(_on_focus_exited)
	self.focus_mode = Control.FOCUS_ALL
	
func disableFocus():
	focus_entered.disconnect(_on_focus_entered)
	focus_exited.disconnect(_on_focus_exited)
	self.focus_mode = Control.FOCUS_NONE

func setMode(mode:Party.Modes):
	self.mode = mode
	update()
	
func setSwapping(swapping:bool):
	self.swapping = swapping
	update()
		
func update():
	if has_focus():
		select()
	else:
		unselect()
		
func swapOut():
	var tween:Tween = create_tween()
	if order == 0 or order == 2 or order == 4:
		await tween.tween_property(self, "position", position+Vector2(-260,0), 0.5)
		#$AnimationPlayer.play("party_animations/SwapOutLeft")
	else:
		await tween.tween_property(self, "position", position+Vector2(260,0), 0.5)
		#$AnimationPlayer.play("party_animations/SwapOutRight")
	await tween.finished
	swappedOut.emit()

func swapIn():
	var tween:Tween = create_tween()
	if order == 0 or order == 2 or order == 4:
		tween.tween_property(self, "position", position+Vector2(260,0), 0.5)
		#$AnimationPlayer.play("party_animations/SwapInLeft")
	else:
		tween.tween_property(self, "position", position+Vector2(-260,0), 0.5)
		#$AnimationPlayer.play("party_animations/SwapInRight")
	await tween.finished
	swappedIn.emit()


func swapInLeft():
	$AnimationPlayer.play("party_animations/swapInLeft")
	
func swapOutRight():
	$AnimationPlayer.play("party_animations/SwapOutRight")
	
func swapInRight():
	$AnimationPlayer.play("party_animations/swapInRight")

#func emitSwappedIn():
	#print("swappedIN")
	#swappedIn.emit()
	#
#func emitSwappedOut():
	#print("swappedOUT")
	#swappedOut.emit()
