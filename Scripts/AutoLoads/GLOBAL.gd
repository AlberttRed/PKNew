extends Node

var Maps: Dictionary = {"Pueblo Paleta" : load("res://Escenas/Mapas/Pueblo Paleta/Pueblo Paleta.tscn"),
						"Ruta 01" : load("res://Escenas/Mapas/Ruta 1/Ruta 01.tscn"),
						"House" : load("res://Escenas/Mapas/Pueblo Paleta/House.tscn"),
						"Ciudad Verde" : load("res://Escenas/Mapas/Ciudad Verde/Ciudad Verde.tscn")
}

var actual_map: Map = null
var previous_map: Map = null

var PLAYER = null
var SCENE_MANAGER

var exit_door = true

var choice_selected:
	get:
		return choice_selected
	set(choice):
		choice_selected = choice





func queue(node):
	if node.is_inside_tree():
		node.propagate_call("queue_free", [])
	else:
		node.propagate_call("call_deferred", ["free"])

func disconnect_signal(node, _signal:String, callable: Callable):
	if node.is_connected(_signal, callable):
		node.disconnect(_signal, callable)


func dec2bin(decimal_value): 
	var binary_string = "" 
	var temp 
	var count = 31 # Checking up to 32 bits 
 
	while(count >= 0): 
		temp = decimal_value >> count 
		if(temp & 1): 
			binary_string = binary_string + "1" 
		else: 
			binary_string = binary_string + "0" 
		count -= 1 

	return int(binary_string)
