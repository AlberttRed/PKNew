extends Node

signal started
signal finished
#signal load_sprite
#signal set_through

@export var image: Texture2D = null
@export var sprite_cols: int = 1
@export var sprite_rows: int = 1
@export var OffsetSprite: Vector2 = Vector2(0,0)

@export var Through: bool = false
@export var Interact: bool = false
@export var DirectionFix: bool = false
@export var PlayerTouch: bool = false
@export var EventTouch: bool = false
@export var AutoRun: bool = false
@export var Paralelo: bool = false

@export var condition1: String = ""
@export var condition2: String = ""
@export var condition3: String = ""

@onready var commands = get_children()
var actual_cmd
var index = -1

var initialFrame = null
#var parentEvent = null


func init_page():
	
	SIGNALS.EVENT_PAGE.load_sprite.emit(image, sprite_cols, sprite_rows, OffsetSprite)
	SIGNALS.EVENT_PAGE.set_through.emit(Through)
	
func exec():
	index = -1
	started.emit()
	#SIGNALS.EVENT_PAGE.started.emit()
	print("page started")
	
	next_command()

func add_choice_cmd(c):
	var y = index
	var choice_node = actual_cmd.get_node(str(c))

	for cmd in choice_node.get_children():
		commands.insert(y+1, cmd)
		y += 1
	
func next_command():
	
	index += 1
	if index < commands.size():
		if actual_cmd != null:
			
			GLOBAL.disconnect_signal(SIGNALS.CMD, "finished", Callable(self, "next_command"))
			if actual_cmd.is_in_group("MSG"):
				GLOBAL.disconnect_signal(SIGNALS.CMD, "selected_choice", Callable(self, "add_choice_cmd"))
		actual_cmd = commands[index] 
			
		if actual_cmd.is_in_group("MSG"):
			if !actual_cmd.choices.is_empty():
				SIGNALS.CMD.connect("selected_choice", Callable(self, "add_choice_cmd"))
			
		SIGNALS.CMD.connect("finished", Callable(self, "next_command"))
		actual_cmd.exec()
	else:

		GLOBAL.disconnect_signal(SIGNALS.CMD, "finished", Callable(self, "next_command"))
		if actual_cmd.is_in_group("MSG"):
			GLOBAL.disconnect_signal(SIGNALS.CMD, "selected_choice", Callable(self, "add_choice_cmd"))
		commands = get_children()
		print("page finished")
		finished.emit()
		#SIGNALS.EVENT_PAGE.finished.emit()
