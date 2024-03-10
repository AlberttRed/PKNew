
extends Panel

signal exit

@export var style_selected: StyleBox
@export var style_empty: StyleBox

var choice_node = load("res://Escenas/UI/Textbox/Choices/choice.tscn")

@onready var entries = []  #get_node("VBoxContainer/Pokedex"),get_node("VBoxContainer/Pokemon"),get_node("VBoxContainer/Mochila"),get_node("VBoxContainer/Jugador"),get_node("VBoxContainer/Guardar"),get_node("VBoxContainer/Opciones"),get_node("VBoxContainer/Salir")]
@onready var container = $VBoxContainer
var choice
var num_of_choices
var signals = []#"pokedex","pokemon","item","player","save","option","exit"]
var start

var can_cancel = true
var default_choice: int = 0

func _init():
	pass

func _ready():
	num_of_choices = -1
	hide()
	exit.connect(Callable(self, "hide"))
	#connect("exit", self, "hide")

var index = 0

func _process(_delta):
	if visible:
		if (INPUT.ui_down.is_action_just_pressed()): #Input.is_action_pressed("ui_down"):#
			var i = index
			while (i < entries.size()-1):
				i+=1
				if (entries[i].is_visible()):
					index=i
					break
			update_styles()
		if (INPUT.ui_up.is_action_just_pressed()):#Input.is_action_pressed("ui_up"):#(INPUT.up.is_action_just_pressed()):
			var i = index
			while (i > 0):
				i-=1
				if (entries[i].is_visible()):
					index=i
					break
			update_styles()
	
		if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
			print("accept " + str(entries[index].name))
			GLOBAL.choice_selected = entries[index]
			emit_signal(entries[index].name, entries[index].name)
			emit_signal("exit")
		if (INPUT.ui_cancel.is_action_just_pressed() and can_cancel):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
			print("cancel")
			GLOBAL.choice_selected = entries[default_choice].name #default_choice
			emit_signal(entries[default_choice].name, entries[default_choice].name)
			emit_signal("exit")
	#	if Input.is_action_pressed("ui_start"):#(INPUT.ui_cancel.is_action_just_pressed()):
	#		emit_signal("exit")

func add_choice(ch):
	num_of_choices = container.get_children().size()
	choice = choice_node.instantiate() # load("res://Escenas/UI/Textbox/Choices/choice.tscn").instantiate()
	print("choice name ", str(ch))
	choice.set_name(ch)
	choice.get_node("ChoiceText").text = ch
	choice.get_node("ChoiceText2").text = ch
	container.add_child(choice)
	size = Vector2(get_rect().size.x, get_rect().size.y + 31*num_of_choices)
	position = Vector2(get_rect().position.x, get_rect().position.y - 31*num_of_choices)
	#signals.push_back("Choice" + str(num_of_choices+1))
	entries.push_back(choice)
	update_styles()
#	if !has_user_signal("Choice" + str(num_of_choices+1)):
#		add_user_signal("Choice" + str(num_of_choices+1))

func show_choices(cancel, default):
	can_cancel = cancel
	default_choice = default
	show()
	
func clear_choices():
	reset_panel()
	hide()
	
func reset_panel():
	size = Vector2(101,57)
	position = Vector2(404,227)
	signals.clear()
	entries.clear()
	for c in container.get_children():
		GLOBAL.queue(c)
		
func update_styles():
	for p in range(entries.size()):
		if (p==index):
			entries[p].add_theme_stylebox_override("panel", style_selected)
			#entries[p].panel = style_selected
		else:
			entries[p].add_theme_stylebox_override("panel", style_empty)
			#entries[p].add_stylebox_override("panel",style_empty)
