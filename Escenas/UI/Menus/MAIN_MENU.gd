
extends Panel

@export var style_selected: StyleBox
@export var style_empty: StyleBox

@onready var entries = [$VBoxContainer/Pokedex,$VBoxContainer/Pokemon,$VBoxContainer/Mochila,$VBoxContainer/Player,$VBoxContainer/Guardar,$VBoxContainer/Opciones,$VBoxContainer/Salir]

var signals = ["pokedex","pokemon","bag","player","save","option","exit"]
var start

signal pokedex
signal pokemon
signal bag
signal player
signal save
signal option
signal exit

#func _init():
#	add_user_signal("pokedex")
#	add_user_signal("pokemon")
#	add_user_signal("bag")
#	add_user_signal("player")
#	add_user_signal("save")
#	add_user_signal("option")
#	add_user_signal("exit")

func _ready():
	hide()
	connect("exit", Callable(self, "hide"))

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
			emit_signal(signals[index])
		if (INPUT.ui_cancel.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
			emit_signal("exit")
		if (INPUT.ui_start.is_action_just_released() or start):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
			start = true
			if (INPUT.ui_start.is_action_just_pressed()):#Input.is_action_pressed("ui_cancel"):#(INPUT.ui_cancel.is_action_just_pressed()):
				emit_signal("exit")
	#	if Input.is_action_pressed("ui_start"):#(INPUT.ui_cancel.is_action_just_pressed()):
	#		emit_signal("exit")

		
func update_styles():
	for p in range(entries.size()):
		if (p==index):
			entries[p].add_theme_stylebox_override("panel", style_selected)
		else:
			entries[p].add_theme_stylebox_override("panel",style_empty)
