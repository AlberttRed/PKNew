
extends Panel

const msgBox_normalSize = Vector2(398, 66)
const msgBox_actionsSize = Vector2(370, 66)

var style_selected
var style_empty

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
@onready var pkmns = [$PKMN_0,$PKMN_1,$PKMN_2,$PKMN_3,$PKMN_4,$PKMN_5]
@onready var actions_chs = [$ACTIONS/VBoxContainer/DATOS,$ACTIONS/VBoxContainer/MOVER,$ACTIONS/VBoxContainer/OBJETO,$ACTIONS/VBoxContainer/SALIR]
@onready var summary = [$SUMMARY/SUMMARY_1,$SUMMARY/SUMMARY_2,$SUMMARY/SUMMARY_3,$SUMMARY/SUMMARY_4,$SUMMARY/SUMMARY_5]
@onready var salir = $Salir
@onready var actions = $ACTIONS
@onready var msg = $MSG

#var signals = ["pokedex","pokemon","item","player","save","option","exit"]
var start
var opened = false

signal exit

func _init():
	pass


func _ready():
	hide()
	for s in summary:
		s.hide()
	actions.hide()
	summary[3].get_node("Move1").visible = false
	summary[3].get_node("Move2").visible = false
	summary[3].get_node("Move3").visible = false
	summary[3].get_node("Move4").visible = false
	#connect("exit", self, "hide")

var index: int = 0
var actions_index = 0
var summary_index = 0

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

#func _input(event):
#	if visible:
#		if INPUT.ui_accept.is_action_just_pressed():#event.is_action_just_pressed("ui_accept"):
#			if get_focus_owner().get_name() == "Salir":
#				emit_signal("salir")
#			else:
#				pass
#				#show_actions
#		elif INPUT.ui_cancel.is_action_just_pressed():#event.is_action_just_pressed("ui_cancel"):
#			index = -1
#			salir.grab_focus()
#			update_styles()
#
				

func _process(_delta):
	if INPUT.ui_accept.is_action_just_released():
		opened = true
	if visible:
		if !actions.visible and !summary[0].visible:
			if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				if get_focus_owner(self).get_name() == "Salir":
						print("no home")
						exit.emit()
				elif opened:
					show_actions()
			if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				print("cuidao")
				if get_focus_owner(self).get_name() == "Salir":
					exit.emit()
				index = -1
				salir.grab_focus()
				update_styles()
		elif actions.visible and !summary[0].visible:
#			if (INPUT.ui_down.is_action_just_pressed()): #Input.is_action_pressed("ui_down"):#
#				var i = actions_index
#				while (i < actions_chs.size()-1):
#					i+=1
#					if (actions_chs[i].is_visible()):
#						actions_index=i
#						break
#				update_styles()
#			if (INPUT.ui_up.is_action_just_pressed()):#Input.is_action_pressed("ui_up"):#(INPUT.up.is_action_just_pressed()):
#				var i = actions_index
#				while (i > 0):
#					i-=1
#					if (actions_chs[i].is_visible()):
#						actions_index=i
#						break
			if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				if actions_index == 0:
					print("SUMMARY")
					show_summaries()
			if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				hide_actions()
				pkmns[index].grab_focus()
		elif summary[0].visible:
			if (INPUT.ui_accept.is_action_just_pressed() or INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
				hide_summaries()
			
			if (INPUT.ui_right.is_action_just_pressed()):
				if summary_index < 4:
					summary_index += 1
					summary[summary_index].show()
			elif (INPUT.ui_left.is_action_just_pressed()):
				if summary_index > 0:
					summary[summary_index].hide()
					summary_index -= 1
				
	#	if Input.is_action_pressed("ui_start"):#(INPUT.ui_cancel.is_action_just_pressed()):
	#		emit_signal("exit")

		
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
		
		if GAME_DATA.party[p].hp_actual == 0:
			type = "fainted"
		else:
			type = "normal"
		
		if (p==index):
			pkmns[p].add_theme_stylebox_override("panel", get("style_" + form + "_" + type + "_sel"))
			pkmns[p].get_node("ball").texture = load("res://Escenas/UI/Menus/Resources/partyBallSel.PNG")
			pkmns[p].get_node("AnimationPlayer").play("PARTY_pkmn_icon_updown")
		else:
			pkmns[p].add_theme_stylebox_override("panel", get("style_" + form + "_" + type))
			pkmns[p].get_node("ball").texture = load("res://Escenas/UI/Menus/Resources/partyBall.PNG")
			pkmns[p].get_node("AnimationPlayer").play("PARTY_pkmn_icon")
	if index == -1:
		salir.add_theme_stylebox_override("panel", style_salir_sel)
	msg.get_node("Label").set_text("Elige un Pokémon.")
	#msg.get_node("Label/Label2").set"Elige un Pokémon."
	msg.size = msgBox_normalSize

func load_pokemon():
	for p in range(GAME_DATA.party.size()):
		pkmns[p].visible = true
		pkmns[p].get_node("Nombre").text = GAME_DATA.party[p].get_nick()
		pkmns[p].get_node("Nombre/Outline").text = GAME_DATA.party[p].get_nick()
		
		pkmns[p].get_node("Nivel").text = "Nv." + str(GAME_DATA.party[p].get_nivel())
		pkmns[p].get_node("Nivel/Outline").text = "Nv." + str(GAME_DATA.party[p].get_nivel())
		
		pkmns[p].get_node("HP").text = str(GAME_DATA.party[p].get_actual_hp()) + "/" + str(GAME_DATA.party[p].get_total_hp())
		pkmns[p].get_node("HP/Outline").text = str(GAME_DATA.party[p].get_actual_hp()) + "/" + str(GAME_DATA.party[p].get_total_hp())
		
		pkmns[p].get_node("pkmn").texture = load("res://Resources/Pokemon/" + str(GAME_DATA.party[p].pkm_id).pad_zeros(3) + ".tres").icon_sprite
		
		var percentage:float = float(GAME_DATA.party[p].hp_actual) / float(GAME_DATA.party[p].hp_total)
		print(percentage)
		pkmns[p].get_node("health_bar/health").scale = Vector2(percentage, 1)
		
		if GAME_DATA.party[p].get_gender() == CONST.GENEROS.MACHO:
			pkmns[p].get_node("gender").texture = load("res://Escenas/UI/Menus/Resources/male_icon.png")
		elif GAME_DATA.party[p].get_gender() == CONST.GENEROS.HEMBRA:
			pkmns[p].get_node("gender").texture = load("res://Escenas/UI/Menus/Resources/female_icon.png")
		else:
			pkmns[p].get_node("gender").texture = null
			
	load_focus()
		
func update_actions_styles():
	for p in range(actions_chs.size()):
		if (p==actions_index):
			actions_chs[p].add_theme_stylebox_override("panel", style_actions_selected)
		else:
			actions_chs[p].add_theme_stylebox_override("panel",style_actions_empty)
	msg.get_node("Label").set_text("¿Qué hacer con " + GAME_DATA.party[index].get_name() + "?")
	#msg.get_node("Label/Label2").text = "¿Qué hacer con " + GAME_DATA.party[index].get_name() + "?"
	msg.size = msgBox_actionsSize

func show_actions():
	print("pe")
	pkmns[index].release_focus()
	#index = -2
	update_styles()
	clear_focus()
	actions_index = 0
	actions_chs[actions_index].grab_focus()
	actions.show()
	update_actions_styles()
	
func hide_actions():
	actions.hide()
	load_focus()
	actions_chs[actions_index].release_focus()
	#pkmns[index].grab_focus()
	update_actions_styles()
	update_styles()
	actions_index = 0

func _on_PKMN_focus_entered():
	index = str(get_focus_owner(self).get_name()).right(1).to_int()
	update_styles()


func _on_Salir_focus_entered():
	index = -1
	update_styles()


func _on_actions_focus_entered():
	match get_focus_owner($ACTIONS/VBoxContainer).get_name():
		"DATOS":
			actions_index = 0
		"MOVER":
			actions_index = 1
		"OBJETO":
			actions_index = 2
		"SALIR":
			actions_index = 3
	update_actions_styles()
	
func load_focus():
	for p in pkmns:
		p.set_focus_mode(2)
	if GAME_DATA.party.size() == 1:
		print("LOL")
		pkmns[0].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[0].set_focus_neighbor(SIDE_RIGHT, "../PKMN_0")
	if GAME_DATA.party.size() == 2:
		pkmns[0].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[1].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
	if GAME_DATA.party.size() == 3:
		pkmns[1].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[2].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[2].set_focus_neighbor(SIDE_RIGHT, "../PKMN_2")
	if GAME_DATA.party.size() == 4:
		pkmns[2].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[3].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
	if GAME_DATA.party.size() == 5:
		pkmns[3].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[4].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[4].set_focus_neighbor(SIDE_RIGHT, "../PKMN_4")
	if GAME_DATA.party.size() == 6:
		pkmns[4].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		pkmns[5].set_focus_neighbor(SIDE_BOTTOM, "../Salir")
		
	
func clear_focus():
	for p in pkmns:
		p.set_focus_mode(0)
#		p.set_focus_neighbour(MARGIN_BOTTOM, "")
#		p.set_focus_neighbour(MARGIN_TOP, "")
#		p.set_focus_neighbour(MARGIN_LEFT, "")
#		p.set_focus_neighbour(MARGIN_RIGHT, "")
	
func clear_actions_focus():
	for a in actions_chs:
		a.set_focus_mode(0)
		a.set_focus_neighbor(SIDE_BOTTOM, null)
		a.set_focus_neighbor(SIDE_TOP, null)
		a.set_focus_neighbor(SIDE_LEFT, null)
		a.set_focus_neighbor(SIDE_RIGHT, null)
		
func show_summaries():
	hide_actions()
	load_summary()
	summary[summary_index].show()
	
func hide_summaries():
	summary_index = 0
	pkmns[index].grab_focus()
	summary[3].get_node("Move1").visible = false
	summary[3].get_node("Move2").visible = false
	summary[3].get_node("Move3").visible = false
	summary[3].get_node("Move4").visible = false
	for s in summary:
		s.hide()
	#show_actions()
	hide_actions()
func load_summary():
	for s in summary:
		# ---- INFO GENERAL --------
		s.get_node("Nombre").text = GAME_DATA.party[index].get_nick()
		s.get_node("Nombre/Outline").text = GAME_DATA.party[index].get_nick()
		
		if GAME_DATA.party[index].get_gender() == CONST.GENEROS.MACHO:
			s.get_node("Genero").texture = load("res://Escenas/UI/Menus/Resources/male_icon.png")
		elif GAME_DATA.party[index].get_gender() == CONST.GENEROS.HEMBRA:
			s.get_node("Genero").texture = load("res://Escenas/UI/Menus/Resources/female_icon.png")
		else:
			s.get_node("Genero").texture = null
			
		#--- falta pokeball
		#--- falta objecte
		#--- falta barra exp
		s.get_node("Nivel").text = str(GAME_DATA.party[index].get_nivel())
		s.get_node("Nivel/Outline").text = str(GAME_DATA.party[index].get_nivel())
		s.get_node("Sprite").texture = load("res://Sprites/Batalla/Battlers/" + str(GAME_DATA.party[index].pkm_id).pad_zeros(3) + ".png")
		
	# ---- SUMMARY 1 --------
		
	summary[0].get_node("dNumDex").text = str(GAME_DATA.party[index].get_id()).pad_zeros(3)
	summary[0].get_node("dNumDex/Outline").text = str(GAME_DATA.party[index].get_id()).pad_zeros(3)
	
	summary[0].get_node("dEspecie").text = GAME_DATA.party[index].get_name()
	summary[0].get_node("dEspecie/Outline").text = GAME_DATA.party[index].get_name()
	
	summary[0].get_node("Tipos/pTipo1/dTipo1").frame = GAME_DATA.party[index].get_type1()

	if  GAME_DATA.party[index].get_type2() != CONST.TYPES.NONE:
		summary[0].get_node("Tipos/pTipo2").visible = true
		summary[0].get_node("Tipos/pTipo2/dTipo2").frame = GAME_DATA.party[index].get_type2()
	else:
		summary[0].get_node("Tipos/pTipo2").visible = false
	
	summary[0].get_node("dEO").text = GAME_DATA.party[index].get_trainer()
	summary[0].get_node("dEO/Outline").text = GAME_DATA.party[index].get_trainer()
	
	summary[0].get_node("dID").text = str(GAME_DATA.party[index].get_dni())
	summary[0].get_node("dID/Outline").text = str(GAME_DATA.party[index].get_dni())
	
	summary[0].get_node("dExperiencia").text = str(GAME_DATA.party[index].get_experiencia())
	summary[0].get_node("dExperiencia/Outline").text = str(GAME_DATA.party[index].get_experiencia())
	
	summary[0].get_node("dSigNivel").text = str(GAME_DATA.party[index].get_exp_next())
	summary[0].get_node("dSigNivel/Outline").text = str(GAME_DATA.party[index].get_exp_next())
	
	# ---- SUMMARY 2 --------

	summary[1].get_node("Naturaleza").text = CONST.NaturesName[GAME_DATA.party[index].get_naturaleza()] + "."
	summary[1].get_node("Naturaleza/Outline").text = CONST.NaturesName[GAME_DATA.party[index].get_naturaleza()] + "."
	
	summary[1].get_node("Labels/FechaCaptura").text = GAME_DATA.party[index].get_fecha_captura()
	summary[1].get_node("Labels/FechaCaptura/Outline").text = GAME_DATA.party[index].get_fecha_captura()
	
	summary[1].get_node("Labels/RutaCaptura").text = GAME_DATA.party[index].get_ruta_captura()
	summary[1].get_node("Labels/RutaCaptura/Outline").text = GAME_DATA.party[index].get_ruta_captura()
	
	summary[1].get_node("Labels/NivelCaptura").text = "Encontrado con Nv. " + str(GAME_DATA.party[index].get_nivel()) + "."
	summary[1].get_node("Labels/NivelCaptura/Outline").text = "Encontrado con Nv. " + str(GAME_DATA.party[index].get_nivel()) + "."
	
	summary[1].get_node("DescNaturaleza").text = GAME_DATA.party[index].get_personality()
	summary[1].get_node("DescNaturaleza/Outline").text = GAME_DATA.party[index].get_personality()
	
	# ---- SUMMARY 3 --------

	summary[2].get_node("dPS").text = str(GAME_DATA.party[index].get_actual_hp()) + "/" + str(GAME_DATA.party[index].hp_total)
	summary[2].get_node("dPS/Outline").text = str(GAME_DATA.party[index].get_actual_hp()) + "/" + str(GAME_DATA.party[index].hp_total)
	
	summary[2].get_node("dAtaque").text = str(GAME_DATA.party[index].get_attack()) 
	summary[2].get_node("dAtaque/Outline").text = str(GAME_DATA.party[index].get_attack()) 
	
	summary[2].get_node("dDefensa").text = str(GAME_DATA.party[index].get_defense()) 
	summary[2].get_node("dDefensa/Outline").text = str(GAME_DATA.party[index].get_defense()) 
	
	summary[2].get_node("dAtEsp").text = str(GAME_DATA.party[index].get_special_attack()) 
	summary[2].get_node("dAtEsp/Outline").text = str(GAME_DATA.party[index].get_special_attack()) 
	
	summary[2].get_node("dDefEsp").text = str(GAME_DATA.party[index].get_special_defense()) 
	summary[2].get_node("dDefEsp/Outline").text = str(GAME_DATA.party[index].get_special_defense()) 
	
	summary[2].get_node("dVelocidad").text = str(GAME_DATA.party[index].get_speed()) 
	summary[2].get_node("dVelocidad/Outline").text = str(GAME_DATA.party[index].get_speed()) 
	
	print(GAME_DATA.party[index].ability_id)
	summary[2].get_node("dHabilidad").text = CONST.AbilitiesName[GAME_DATA.party[index].ability_id]
	summary[2].get_node("dHabilidad/Outline").text = CONST.AbilitiesName[GAME_DATA.party[index].ability_id]
	
	summary[2].get_node("DescHabilidad").text = CONST.AbilitiesDesc[GAME_DATA.party[index].get_ability()]
	summary[2].get_node("DescHabilidad/Outline").text = CONST.AbilitiesDesc[GAME_DATA.party[index].get_ability()]
	
	# ---- SUMMARY 3 --------
	print(str(GAME_DATA.party[index].movements.size()))
	for i in range(GAME_DATA.party[index].movements.size()):
		print(GAME_DATA.party[index].movements[i].get_type_name())
		summary[3].get_node("Move" + str(i+1)).visible = true
		summary[3].get_node("Move" + str(i+1) + "/Ataque").text = GAME_DATA.party[index].movements[i].get_name()
		summary[3].get_node("Move" + str(i+1) + "/Ataque/Outline").text = GAME_DATA.party[index].movements[i].get_name()
		summary[3].get_node("Move" + str(i+1) + "/Tipo").frame = GAME_DATA.party[index].movements[i].get_move_type().id
		summary[3].get_node("Move" + str(i+1) + "/dPP").text = str(GAME_DATA.party[index].movements[i].pp_actual) + "/" + str(GAME_DATA.party[index].movements[i].pp)
		summary[3].get_node("Move" + str(i+1) + "/dPP/Outline").text = str(GAME_DATA.party[index].movements[i].pp_actual) + "/" + str(GAME_DATA.party[index].movements[i].pp)

func get_focus_owner(parent):
	for c in parent.get_children():
		if c is Panel:
			if c.has_focus():
				return c
			
