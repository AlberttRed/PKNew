
extends Panel

const msgBox_normalSize = Vector2(398, 66)
const msgBox_actionsSize = Vector2(370, 66)

var style_selected
var style_empty

enum ACTION_PANEL {NONE, DATOS, CAMBIO, MOVER, OBJETO, SALIR}

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

@export var style_salir : StyleBox
@export var style_salir_sel : StyleBox

@export var style_actions_empty : StyleBox
@export var style_actions_selected : StyleBox
#"ACTIONS/VBoxContainer/SALIR"
@onready var pkmns = [$PKMN_0/Panel,$PKMN_1/Panel,$PKMN_2/Panel,$PKMN_3/Panel,$PKMN_4/Panel,$PKMN_5/Panel]
#@onready var actions_chs = [$ACTIONS/VBoxContainer/NONE, $ACTIONS/VBoxContainer/DATOS,$ACTIONS/VBoxContainer/CAMBIO,$ACTIONS/VBoxContainer/MOVER,$ACTIONS/VBoxContainer/OBJETO,$ACTIONS/VBoxContainer/SALIR]
#@onready var actions_chs = []
@onready var summary = [$SUMMARY/SUMMARY_1,$SUMMARY/SUMMARY_2,$SUMMARY/SUMMARY_3,$SUMMARY/SUMMARY_4,$SUMMARY/SUMMARY_5]
@onready var salir = $Salir
@onready var actions:ChoicesContainer = $ACTIONS
@onready var fixedMsg = $FIXED_MSG
@onready var msgBox:MessageBox = MessageBox.new($MSG)

var partyMode:CONST.MENU_MODES

#var signals = ["pokedex","pokemon","item","player","save","option","exit"]
var start
var opened = false

var movingPokemon:bool = false
var movePokemonOriginIndex:int = -1
var movePokemonTargetIndex:int = -1
var swapping:bool = false

var index: int = 0 #Index used to move pokemon targets
var actions_index:int = ACTION_PANEL.NONE #Index used to move between panel actions
var summary_index = 0 #Index used to move between summaries pages
var movingIndex: int = 0 #Index used to move between pokemon summaries


signal exit
signal swappedOut
signal swappedIn
signal pokemonSelected

func _init():
	pass


func _ready():
	hide()
	clear_focus()
	for s in summary:
		s.hide()
	actions.hide()
	summary[3].get_node("Move1").visible = false
	summary[3].get_node("Move2").visible = false
	summary[3].get_node("Move3").visible = false
	summary[3].get_node("Move4").visible = false
	#connect("exit", self, "hide")

func open(mode:CONST.MENU_MODES):
	index = 0
	partyMode = mode
	hide_actions()
	print("open party")
	GUI.accept.connect(Callable(self, "selectOption"))
	GUI.cancel.connect(Callable(self, "cancelOption"))
	GUI.left.connect(Callable(self, "moveLeft"))
	GUI.right.connect(Callable(self, "moveRight"))
	GUI.up.connect(Callable(self, "moveUp"))
	GUI.down.connect(Callable(self, "moveDown"))
	for p in pkmns:
		p.get_node("AnimationPlayer").play("party_animations/RESET")
	load_pokemon()

	pkmns[index].grab_focus()
	setFixedMsgText("Elige a un Pokémon.")
	update_styles()
	show()
	if GUI.isFading():
		await GUI.fadeOut(3)
		#await GUI.fadedOut
	load_focus()
	
func close():
	print("close party")
	GUI.accept.disconnect(Callable(self, "selectOption"))
	GUI.cancel.disconnect(Callable(self, "cancelOption"))
	GUI.left.disconnect(Callable(self, "moveLeft"))
	GUI.right.disconnect(Callable(self, "moveRight"))
	GUI.up.disconnect(Callable(self, "moveUp"))
	GUI.down.disconnect(Callable(self, "moveDown"))
	await GUI.fadeIn(3)
	hide()
	exit.emit()
	
func selectOption():
	if !msgBox.is_visible():
		if !actions.visible and !$SUMMARY.visible:
			if get_focus_owner(self).get_name() == "Salir":
				if movingPokemon:
					cancelMovePokemon()
				close()
			else:
				if partyMode == CONST.MENU_MODES.MENU:
					if !movingPokemon:
						show_PartyActions()
					else:
						movePokemonTargetIndex = index
						await swapPokemon()
				elif partyMode == CONST.MENU_MODES.BATTLE:
					show_BattleActions()
					
		elif actions.visible and !$SUMMARY.visible:
			if actions.isSelected("DATOS"):
				show_summaries()
			elif actions.isSelected("CAMBIO"):
				if !GAME_DATA.party[index].inBattle:
					pokemonSelected.emit(GAME_DATA.party[index])
					close()
				else:
					await showMsg(GAME_DATA.party[index].Name + " ya está en el campo de batalla!")
			elif actions.isSelected("MOVER"):
				selectMovePokemon()
			elif actions.isSelected("OBJETO"):
				print("objeto")
			elif actions.isSelected("SALIR"):
				cancelOption()
		elif $SUMMARY.visible:
			hide_summaries()
			
func showMsg(text:String):
	if actions.visible:
		actions.hide()
	msgBox.position = Vector2(0, 288)
	msgBox.show_msgBattle(text, false, 0.0, true)
	await msgBox.finished
	msgBox.clear_msg()
	actions.show()
	
func cancelOption():
	if !msgBox.is_visible():
		if !actions.visible and !$SUMMARY.visible:
			if movingPokemon:
				cancelMovePokemon()
				if get_focus_owner(self).get_name() == "Salir":
					close()
			else:
				if get_focus_owner(self).get_name() == "Salir":
					close()
				index = -1
				salir.grab_focus()
				update_styles()
		elif actions.visible and !$SUMMARY.visible:
			hide_actions()
			pkmns[index].grab_focus()
		elif $SUMMARY.visible:
			hide_summaries()

func moveRight():
	if $SUMMARY.visible:
		if summary_index < 4:
			summary_index += 1
			summary[summary_index].show()
		
func moveLeft():
	if $SUMMARY.visible:
		if summary_index > 0:
			summary[summary_index].hide()
			summary_index -= 1

func moveUp():
	if $SUMMARY.visible:
		if movingIndex > 0:
			movingIndex -= 1
		load_summary(movingIndex)
		
func moveDown():
	if $SUMMARY.visible:
		if movingIndex < 5:
			movingIndex += 1
		load_summary(movingIndex)

func selectMovePokemon():
	var form = ""
	var type = ""
	if !movingPokemon:
		hide_actions()
		pkmns[index].grab_focus()
		movingPokemon = true
		movePokemonOriginIndex = index

		update_styles()
		
func swapPokemon():
	swapping = true
	if movePokemonOriginIndex == 0 or movePokemonOriginIndex == 2 or movePokemonOriginIndex == 4: #LEFT
		pkmns[movePokemonOriginIndex].get_node("AnimationPlayer").play("party_animations/SwapOutLeft")
	else: #RIGHT
		pkmns[movePokemonOriginIndex].get_node("AnimationPlayer").play("party_animations/SwapOutRight")

	if movePokemonTargetIndex == 0 or movePokemonTargetIndex == 2 or movePokemonTargetIndex == 4: #LEFT
		pkmns[movePokemonTargetIndex].get_node("AnimationPlayer").play("party_animations/SwapOutLeft")
	else: #RIGHT
		pkmns[movePokemonTargetIndex].get_node("AnimationPlayer").play("party_animations/SwapOutRight")
		
	await swappedOut
	
	var pOrigin = GAME_DATA.party[movePokemonOriginIndex]
	var pTarget = GAME_DATA.party[movePokemonTargetIndex]
	
	GAME_DATA.party[movePokemonOriginIndex] = pTarget
	GAME_DATA.party[movePokemonTargetIndex] = pOrigin
	
	load_pokemon()


	if movePokemonOriginIndex == 0 or movePokemonOriginIndex == 2 or movePokemonOriginIndex == 4: #LEFT
		pkmns[movePokemonOriginIndex].get_node("AnimationPlayer").play("party_animations/SwapInLeft")
	else: #RIGHT
		pkmns[movePokemonOriginIndex].get_node("AnimationPlayer").play("party_animations/SwapInRight")

	if movePokemonTargetIndex == 0 or movePokemonTargetIndex == 2 or movePokemonTargetIndex == 4: #LEFT
		pkmns[movePokemonTargetIndex].get_node("AnimationPlayer").play("party_animations/SwapInLeft")
	else: #RIGHT
		pkmns[movePokemonTargetIndex].get_node("AnimationPlayer").play("party_animations/SwapInRight")
		
	await swappedIn
	
	index = movePokemonTargetIndex
	cancelMovePokemon()
	pkmns[index].grab_focus()
	swapping = false
	#setPanelFocus()
	
func cancelMovePokemon():
	movingPokemon = false
	movePokemonOriginIndex = -1
	movePokemonTargetIndex = -1
	update_styles()
	
func show_party():
	opened = false
	load_pokemon()
	update_styles()
	pkmns[0].grab_focus()
	show()
	
	
func hide_party():
	for p in range(GAME_DATA.party.size()):
		pkmns[p].visible = false
	opened = false
	hide()

func setSwapping(swap:bool):
	swapping = swap
	
func emitSwappedIn():
	print("swappedIN")
	swappedIn.emit()
	

func emitSwappedOut():
	print("swappedOUT")
	swappedOut.emit()
			
func update_styles():
	var form = ""
	var type = ""
#	if index != -1:
	salir.add_theme_stylebox_override("panel", style_salir)

	for p in range(pkmns.size()):
		if p == 0:
			form = "rounded"
		else:
			form = "square"

		if p==index:
			if GAME_DATA.party[p].fainted:
				type = "fainted_sel"
			elif !movingPokemon:
				type = "normal_sel"
			elif movingPokemon:
				if movePokemonOriginIndex == p:
					type = "swap"
				else:
					type = "swap_sel"
				
			pkmns[p].add_theme_stylebox_override("panel", get("style_" + form + "_" + type))
			pkmns[p].get_node("ball").texture = load("res://Escenas/UI/Menus/Resources/partyBallSel.PNG")
			pkmns[p].get_node("AnimationPlayer").play("party_animations/PARTY_pkmn_icon_updown")
		else:
			if GAME_DATA.party[p].fainted:
				type = "fainted"
			elif !movingPokemon or (movingPokemon && movePokemonOriginIndex != p):
				type = "normal"
			elif movingPokemon && movePokemonOriginIndex == p:
				type = "swap"
			pkmns[p].add_theme_stylebox_override("panel", get("style_" + form + "_" + type))
			pkmns[p].get_node("ball").texture = load("res://Escenas/UI/Menus/Resources/partyBall.PNG")
			pkmns[p].get_node("AnimationPlayer").play("party_animations/PARTY_pkmn_icon")
			
		
	if index == -1:
		salir.add_theme_stylebox_override("panel", style_salir_sel)

	
func setFixedMsgText(text:String, boxSize:Vector2 = msgBox_normalSize):
	fixedMsg.get_node("Label").setText(text)
	fixedMsg.size = boxSize

func load_pokemon():
	for p in range(GAME_DATA.party.size()):
		pkmns[p].visible = true
		pkmns[p].get_node("Nombre").text = GAME_DATA.party[p].Name
		pkmns[p].get_node("Nombre/Outline").text = GAME_DATA.party[p].Name
		
		pkmns[p].get_node("Nivel").text = "Nv." + str(GAME_DATA.party[p].level)
		pkmns[p].get_node("Nivel/Outline").text = "Nv." + str(GAME_DATA.party[p].level)
		
		
		if GAME_DATA.party[p].fainted:
			pkmns[p].get_node("Status").visible = true
			pkmns[p].get_node("Status").region_enabled = false
			pkmns[p].get_node("Status").region_rect = Rect2(0, 16*(CONST.STATUS.FAINTED-1), 44, 16)
		else:
			if GAME_DATA.party[p].status != CONST.STATUS.OK:
				pkmns[p].get_node("Status").region_enabled = true
				pkmns[p].get_node("Status").visible = true
				pkmns[p].get_node("Status").region_rect = Rect2(0, 16*(GAME_DATA.party[p].status-1), 44, 16)
			else:
				pkmns[p].get_node("Status").visible = false

		pkmns[p].get_node("health_bar").init(GAME_DATA.party[p])
		
		pkmns[p].get_node("pkmn").texture = load("res://Resources/Pokemon/" + str(GAME_DATA.party[p].pkm_id).pad_zeros(3) + ".tres").icon_sprite
		
		var percentage:float = float(GAME_DATA.party[p].hp_actual) / float(GAME_DATA.party[p].hp_total)
		print(percentage)
		#pkmns[p].get_node("health_bar/health").scale = Vector2(percentage, 1)
		
		if GAME_DATA.party[p].gender == CONST.GENEROS.MACHO:
			pkmns[p].get_node("gender").texture = load("res://Escenas/UI/Menus/Resources/male_icon.png")
		elif GAME_DATA.party[p].gender == CONST.GENEROS.HEMBRA:
			pkmns[p].get_node("gender").texture = load("res://Escenas/UI/Menus/Resources/female_icon.png")
		else:
			pkmns[p].get_node("gender").texture = null
			
		
func showActions():
	setFixedMsgText("¿Qué hacer con " + GAME_DATA.party[index].Name + "?", msgBox_actionsSize)
	pkmns[index].release_focus()
	update_styles()
	clear_focus()
	actions.showContainer()

func show_PartyActions():
	actions.activeChoices(["DATOS","MOVER","OBJETO","SALIR"])
	showActions()

func show_BattleActions():
	actions.activeChoices(["CAMBIO","DATOS","SALIR"])
	showActions()

func hide_actions():
	setFixedMsgText("Elige a un Pokémon.")
	actions.hideContainer()
	load_focus()
	update_styles()

func setPanelFocus():
	var panelName:String = str(get_focus_owner(self).get_parent().get_name())
	print(panelName)
	index = panelName.right(1).to_int()
	update_styles()
	
func _on_PKMN_focus_entered():
	if !swapping && !GUI.isFading():
		setPanelFocus()
	


func _on_Salir_focus_entered():
	if !swapping && !GUI.isFading():
		index = -1
		update_styles()

#
#func _on_actions_focus_entered():
	#if !GUI.isFading():
		#match get_focus_owner($ACTIONS/VBoxContainer).get_name():
			#"DATOS":
				#actions_index = ACTION_PANEL.DATOS
			#"CAMBIO":
				#actions_index = ACTION_PANEL.CAMBIO
			#"MOVER":
				#actions_index = ACTION_PANEL.MOVER
			#"OBJETO":
				#actions_index = ACTION_PANEL.OBJETO
			#"SALIR":
				#actions_index = ACTION_PANEL.SALIR
		#update_actions_styles()
	#
func load_focus():
	for p in pkmns:
		p.set_focus_mode(Control.FOCUS_ALL)
	if GAME_DATA.party.size() == 1:
		print("LOL")
		pkmns[0].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[0].set_focus_neighbor(SIDE_RIGHT, "../../PKMN_0/Panel")
	if GAME_DATA.party.size() == 2:
		pkmns[0].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[1].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
	if GAME_DATA.party.size() == 3:
		pkmns[1].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[2].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[2].set_focus_neighbor(SIDE_RIGHT, "../../PKMN_2/Panel")
	if GAME_DATA.party.size() == 4:
		pkmns[2].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[3].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
	if GAME_DATA.party.size() == 5:
		pkmns[3].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[4].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[4].set_focus_neighbor(SIDE_RIGHT, "../../PKMN_4/Panel")
	if GAME_DATA.party.size() == 6:
		pkmns[4].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
		pkmns[5].set_focus_neighbor(SIDE_BOTTOM, "../../Salir")
	pkmns[index].grab_focus()
	
func clear_focus():
	for p in pkmns:
		p.set_focus_mode(Control.FOCUS_NONE)
#		p.set_focus_neighbour(MARGIN_BOTTOM, "")
#		p.set_focus_neighbour(MARGIN_TOP, "")
#		p.set_focus_neighbour(MARGIN_LEFT, "")
#		p.set_focus_neighbour(MARGIN_RIGHT, "")
	
#func clear_actions_focus():
	#for a in actions_chs:
		#a.set_focus_mode(0)
		#a.set_focus_neighbor(SIDE_BOTTOM, null)
		#a.set_focus_neighbor(SIDE_TOP, null)
		#a.set_focus_neighbor(SIDE_LEFT, null)
		#a.set_focus_neighbor(SIDE_RIGHT, null)
		#
func show_summaries():
	await GUI.fadeIn(3)
	hide_actions()
	clear_focus()
	load_summary(index)
	movingIndex = index
	$SUMMARY.visible = true
	summary[summary_index].show()
	await GUI.fadeOut(3)
	
func hide_summaries():
	await GUI.fadeIn(3)
	summary_index = 0
	pkmns[index].grab_focus()
	movingIndex = index
	$SUMMARY.visible = false
	summary[3].get_node("Move1").visible = false
	summary[3].get_node("Move2").visible = false
	summary[3].get_node("Move3").visible = false
	summary[3].get_node("Move4").visible = false
	$SUMMARY/GENERAL.visible = false
	for s in summary:
		s.hide()
	#show_actions()
	hide_actions()
	await GUI.fadeOut(3)

func load_summary(index:int):
	$SUMMARY/GENERAL.visible = true
# ---- GENERAL --------
	$SUMMARY/GENERAL.get_node("Nombre").text = GAME_DATA.party[index].Name
	$SUMMARY/GENERAL.get_node("Nombre/Outline").text = GAME_DATA.party[index].Name
	
	if GAME_DATA.party[index].gender == CONST.GENEROS.MACHO:
		$SUMMARY/GENERAL.get_node("Genero").texture = load("res://Escenas/UI/Menus/Resources/male_icon.png")
	elif GAME_DATA.party[index].gender == CONST.GENEROS.HEMBRA:
		$SUMMARY/GENERAL.get_node("Genero").texture = load("res://Escenas/UI/Menus/Resources/female_icon.png")
	else:
		$SUMMARY/GENERAL.get_node("Genero").texture = null

	if GAME_DATA.party[index].fainted:
		$SUMMARY/GENERAL.get_node("Status").visible = true
		$SUMMARY/GENERAL.get_node("Status").region_enabled = false
		$SUMMARY/GENERAL.get_node("Status").region_rect = Rect2(0, 16*(CONST.STATUS.FAINTED-1), 44, 16)
	else:
		if GAME_DATA.party[index].status != CONST.STATUS.OK:
			$SUMMARY/GENERAL.get_node("Status").region_enabled = true
			$SUMMARY/GENERAL.get_node("Status").visible = true
			$SUMMARY/GENERAL.get_node("Status").region_rect = Rect2(0, 16*(GAME_DATA.party[index].status-1), 44, 16)
		else:
			$SUMMARY/GENERAL.get_node("Status").visible = false
	#--- falta pokeball
	#--- falta objecte
	#--- falta barra exp
	$SUMMARY/GENERAL.get_node("Nivel").text = str(GAME_DATA.party[index].level)
	$SUMMARY/GENERAL.get_node("Nivel/Outline").text = str(GAME_DATA.party[index].level)
	$SUMMARY/GENERAL.get_node("Sprite").texture = GAME_DATA.party[index].battle_front_sprite#load("res://Sprites/Batalla/Battlers/" + str(GAME_DATA.party[index].pkm_id).pad_zeros(3) + ".png")
	
	# ---- SUMMARY 1 --------
		
	summary[0].get_node("dNumDex").text = str(GAME_DATA.party[index].pkm_id).pad_zeros(3)
	summary[0].get_node("dNumDex/Outline").text = str(GAME_DATA.party[index].pkm_id).pad_zeros(3)
	
	summary[0].get_node("dEspecie").text = GAME_DATA.party[index].Name
	summary[0].get_node("dEspecie/Outline").text = GAME_DATA.party[index].Name
	summary[0].get_node("Tipos/pTipo1/dTipo1").vframes = 1
	summary[0].get_node("Tipos/pTipo1/dTipo1").texture = GAME_DATA.party[index].type_a.image#frame = GAME_DATA.party[index].type_a

	if  GAME_DATA.party[index].type_b != null:
		summary[0].get_node("Tipos/pTipo2").visible = true
		summary[0].get_node("Tipos/pTipo2/dTipo2").vframes = 1
		summary[0].get_node("Tipos/pTipo2/dTipo2").texture = GAME_DATA.party[index].type_b.image#.frame = GAME_DATA.party[index].type_b
	else:
		summary[0].get_node("Tipos/pTipo2").visible = false
	
	summary[0].get_node("dEO").text = GAME_DATA.party[index].original_trainer
	summary[0].get_node("dEO/Outline").text = GAME_DATA.party[index].original_trainer
	
	summary[0].get_node("dID").text = str(GAME_DATA.party[index].trainer_id)
	summary[0].get_node("dID/Outline").text = str(GAME_DATA.party[index].trainer_id)
	
	summary[0].get_node("dExperiencia").text = str(GAME_DATA.party[index].totalExp)
	summary[0].get_node("dExperiencia/Outline").text = str(GAME_DATA.party[index].totalExp)
	
	summary[0].get_node("dSigNivel").text = str(GAME_DATA.party[index].nextLevelExpBase)
	summary[0].get_node("dSigNivel/Outline").text = str(GAME_DATA.party[index].nextLevelExpBase)

	summary[0].get_node("exp_bar").get_node("TextureProgressBar").max_value = GAME_DATA.party[index].nextLevelExpBase
	summary[0].get_node("exp_bar").get_node("TextureProgressBar").min_value = GAME_DATA.party[index].actualLevelExpBase
	summary[0].get_node("exp_bar").get_node("TextureProgressBar").value = GAME_DATA.party[index].totalExp
	
	# ---- SUMMARY 2 --------

	summary[1].get_node("Naturaleza").text = CONST.NaturesName[GAME_DATA.party[index].nature_id] + "."
	summary[1].get_node("Naturaleza/Outline").text = CONST.NaturesName[GAME_DATA.party[index].nature_id] + "."
	
	summary[1].get_node("Labels/FechaCaptura").text = GAME_DATA.party[index].capture_date
	summary[1].get_node("Labels/FechaCaptura/Outline").text = GAME_DATA.party[index].capture_date
	
	summary[1].get_node("Labels/RutaCaptura").text = GAME_DATA.party[index].capture_route
	summary[1].get_node("Labels/RutaCaptura/Outline").text = GAME_DATA.party[index].capture_route
	
	summary[1].get_node("Labels/NivelCaptura").text = "Encontrado con Nv. " + str(GAME_DATA.party[index].capture_level) + "."
	summary[1].get_node("Labels/NivelCaptura/Outline").text = "Encontrado con Nv. " + str(GAME_DATA.party[index].capture_level) + "."
	
	summary[1].get_node("DescNaturaleza").text = GAME_DATA.party[index].personality
	summary[1].get_node("DescNaturaleza/Outline").text = GAME_DATA.party[index].personality
	
	# ---- SUMMARY 3 --------

	summary[2].get_node("dPS").text = str(GAME_DATA.party[index].hp_actual) + "/" + str(GAME_DATA.party[index].hp_total)
	summary[2].get_node("dPS/Outline").text = str(GAME_DATA.party[index].hp_actual) + "/" + str(GAME_DATA.party[index].hp_total)
	
	summary[2].get_node("health_bar").init(GAME_DATA.party[index])
	
	summary[2].get_node("ValueStats").get_node("dAtaque").text = str(GAME_DATA.party[index].attack) 
	summary[2].get_node("ValueStats").get_node("dAtaque/Outline").text = str(GAME_DATA.party[index].attack) 
	
	summary[2].get_node("ValueStats").get_node("dDefensa").text = str(GAME_DATA.party[index].defense) 
	summary[2].get_node("ValueStats").get_node("dDefensa/Outline").text = str(GAME_DATA.party[index].defense) 
	
	summary[2].get_node("ValueStats").get_node("dAtEsp").text = str(GAME_DATA.party[index].special_attack) 
	summary[2].get_node("ValueStats").get_node("dAtEsp/Outline").text = str(GAME_DATA.party[index].special_attack) 
	
	summary[2].get_node("ValueStats").get_node("dDefEsp").text = str(GAME_DATA.party[index].special_defense)
	summary[2].get_node("ValueStats").get_node("dDefEsp/Outline").text = str(GAME_DATA.party[index].special_defense) 
	
	summary[2].get_node("ValueStats").get_node("dVelocidad").text = str(GAME_DATA.party[index].speed) 
	summary[2].get_node("ValueStats").get_node("dVelocidad/Outline").text = str(GAME_DATA.party[index].speed) 
	
	print(GAME_DATA.party[index].ability_id)
	summary[2].get_node("dHabilidad").text = CONST.AbilitiesName[GAME_DATA.party[index].ability_id]
	summary[2].get_node("dHabilidad/Outline").text = CONST.AbilitiesName[GAME_DATA.party[index].ability_id]
	
	summary[2].get_node("DescHabilidad").text = CONST.AbilitiesDesc[GAME_DATA.party[index].ability_id]
	summary[2].get_node("DescHabilidad/Outline").text = CONST.AbilitiesDesc[GAME_DATA.party[index].ability_id]
	
	# ---- SUMMARY 3 --------
	print(str(GAME_DATA.party[index].movements.size()))
	for i in range(GAME_DATA.party[index].movements.size()):
		print(GAME_DATA.party[index].movements[i].type.Name)
		summary[3].get_node("Move" + str(i+1)).visible = true
		summary[3].get_node("Move" + str(i+1) + "/Ataque").text = GAME_DATA.party[index].movements[i].Name
		summary[3].get_node("Move" + str(i+1) + "/Ataque/Outline").text = GAME_DATA.party[index].movements[i].Name
		summary[3].get_node("Move" + str(i+1) + "/Tipo").frame = GAME_DATA.party[index].movements[i].type.id
		summary[3].get_node("Move" + str(i+1) + "/dPP").text = str(GAME_DATA.party[index].movements[i].pp_actual) + "/" + str(GAME_DATA.party[index].movements[i].pp)
		summary[3].get_node("Move" + str(i+1) + "/dPP/Outline").text = str(GAME_DATA.party[index].movements[i].pp_actual) + "/" + str(GAME_DATA.party[index].movements[i].pp)

func get_focus_owner(parent):
	for c in parent.get_children():
		var p
		if c is Panel:
			p = c
		else:
			p = c.get_node("Panel")
		if p.has_focus():
			return p


