
extends Node

#signal cmd_started
#signal cmd_finished
#signal selected_choice

@export_multiline var text: String = ""
@export var choices: Array[String] = []
@export var can_cancel: bool = false
@export var default_at_cancel: int = 0
#var running = false
#var executing = false
#var parentEvent = null
#var parentPage = null

func _ready():
	add_to_group(str(GLOBAL.actual_map.name))


func exec():
	#print("cmd groups ",  get_groups())
	SignalManager.CMD.started.emit()
	print("cmd_msg started")
	GUI.connect("input", Callable(self, "finish_cmd"))
	if !choices.is_empty():
		GUI.connect("selected_choice", Callable(self, "add_choice_cmd"))

	GUI.show_msg(text, null, null, null, [choices,can_cancel,default_at_cancel], !is_continuous_message())#, is_continuous_message())
	
func is_continuous_message():
	if get_child_count() > 0:
		if "cmd_msg" in get_child(0).get_name():
			return true
	return false
		
func add_choice_cmd(c):
	SignalManager.CMD.selected_choice.emit(c)
	
func finish_cmd():
	GUI.disconnect("input", Callable(self, "finish_cmd"))
	GLOBAL.disconnect_signal(GUI, "selected_choice", Callable(self, "add_choice_cmd"))
	print("cmd_msg finished")
	SignalManager.CMD.finished.emit()
