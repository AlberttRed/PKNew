extends Node

class_name MoveInstance

var base : Move

var id  : int :
	get:
		return base.id
	set(value):
		id = value 

var internalName : String :
	get:
		return base.internal_name
	set(value):
		internalName = value 

var Name : String :
	get:
		return base.Name
	set(value):
		Name = value 

var description : String :
	get:
		return base.description
	set(value):
		description = value 

var power : int :
	get:
		return base.power
	set(value):
		power = value 

var accuracy : int :
	get:
		return base.accuracy
	set(value):
		accuracy = value 

var type : Resource :
	get:
		return base.type
	set(value):
		type = value 

var priority : int :
	get:
		return base.priority
	set(value):
		priority = value 

var damage_class : int :
	get:
		return base.damage_class_id
	set(value):
		damage_class = value

var pp = 5
var pp_actual = 5
var mod_pp = 0

#func get_name():
#	return DB.Moves[id].Name
#func get_power():
#	return DB.Moves[id].power
#func get_acuracy():
#	return DB.Moves[id].acuracy
#
#func get_move_type():
#	return DB.Types[DB.Moves[id].type.to_int()]
#
#func get_type_name():
#	return DB.Types[DB.Moves[id].type.to_int()].Name
#
#func get_priority():
#	return DB.Moves[id].priority
	
func _init(_move_id : int = -1) -> void:
	if _move_id != -1:
		var t_num : String = "%03d" % _move_id
		self.base = load("res://Resources/Moves/" + t_num + ".tres")
		pp = base.pp
		pp_actual = pp

#func doMove(from,to):
#	DB.moves[id].ShowAnimation(from,to)
#	yield(DB.moves[id], "animation_done")
#	DB.moves[id].doMove(self,from,to)
#	yield(DB.moves[id], "move_done")
#
#func ShowAnimation(from,to):
#	DB.moves[id].ShowAnimation(from,to)
#	yield(DB.moves[id], "animation_done")

func is_type(type): return type == "Move" or self.is_type(type)
func    get_type(): return "Move"

func print_move():
	print(" ------ " + str(Name) + " " + str(pp_actual) + "/" + str(pp) + " PP ------ ")
