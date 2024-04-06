
extends Panel

@export var style_selected: StyleBox
@export var style_empty: StyleBox

@onready var entries:Array[Control] = [$VBoxContainer/Pokedex,$VBoxContainer/Pokemon,$VBoxContainer/Mochila,$VBoxContainer/Player,$VBoxContainer/Guardar,$VBoxContainer/Opciones,$VBoxContainer/Salir]

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

var index:int = 0

func _ready():
	hide()

func selectOption():
	emit_signal(signals[index])

func open():
	print("open start menu")
	GUI.accept.connect(Callable(self, "selectOption"))
	GUI.cancel.connect(Callable(self, "close"))
	GUI.start.connect(Callable(self, "close"))
	GUI.up.connect(Callable(self, "moveUp"))
	GUI.down.connect(Callable(self, "moveDown"))
	show()
	
func close():
	print("close start menu")
	GUI.accept.disconnect(Callable(self, "selectOption"))
	GUI.cancel.disconnect(Callable(self, "close"))
	GUI.start.disconnect(Callable(self, "close"))
	GUI.up.disconnect(Callable(self, "moveUp"))
	GUI.down.disconnect(Callable(self, "moveDown"))
	hide()
	exit.emit()

func moveUp():
	var i = index
	while (i > 0):
		i-=1
		if (entries[i].is_visible()):
			index=i
			break
	update_styles()
	
func moveDown():
	var i = index
	while (i < entries.size()-1):
		i+=1
		if (entries[i].is_visible()):
			index=i
			break
	update_styles()
	
func update_styles():
	for p in range(entries.size()):
		if (p==index):
			entries[p].get_node("Arrow").add_theme_stylebox_override("panel", style_selected)
		else:
			entries[p].get_node("Arrow").add_theme_stylebox_override("panel",style_empty)
	
