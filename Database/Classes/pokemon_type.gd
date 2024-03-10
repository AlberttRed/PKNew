
extends Node

@export var internal_name : String = ""
@export var Name : String = ""
@export var id : int = 0
@export var ineffective: Array # the types this type is ineffective against.
@export var no_effect_to: Array # the types this type has no effect against.
@export var no_effect_from: Array # the types this type has no effect from.
@export var resistance: Array # the types this type is resistant to.
@export var super_effective: Array # the types this type is super effective against.
@export var weakness: Array # the types this type is weak to.
@export var panelMove_y: int = 0 #la posició del panel en la imatge
@export var typeImage : Texture = null

func get_typeImage():
	return get_node("TypeImage").frame
	
func get_effectiveness_from(type):
	if no_effect_from.has(type):
		return 0
	elif resistance.has(type):
		return 0.5
	elif weakness.has(type):
		return 2
	else:
		return 1
		
func get_effectiveness_against(type):
	if no_effect_to.has(type):
		return 0
	elif ineffective.has(type):
		return 0.5
	elif super_effective.has(type):
		return 2
	else:
		return 1
