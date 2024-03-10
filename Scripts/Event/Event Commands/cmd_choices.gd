
extends Node

@export var choices: Array[String]
var parentEvent = null
var parentPage = null

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))

func _init():
	add_user_signal("finished")

func run():
	print("show choices started")
	GUI.show_choices(choices)
	while (GUI.isVisible()):
		await get_tree().process_frame
		#yield(get_tree(),"idle_frame")
	print("show choices finished")
	parentPage.finished_command()
	emit_signal("finished")
	


