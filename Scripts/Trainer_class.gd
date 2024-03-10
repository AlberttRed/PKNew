class_name Trainer2

export(String)var Name
export(Texture)var battle_front_sprite
export(Texture)var battle_back_sprite = null
export(String,MULTILINE)var before_battle_message
export(String,MULTILINE)var init_battle_message
export(String,MULTILINE)var end_battle_message
export(bool)var is_defeated = false
export(bool)var double_battle = false
export(bool)var is_playable = false
export(NodePath)var partner = null #Aqui hi lligarem l'NPC que fagi de parella a lhora del combat. A PARTIR DE L NPC AGAFAREM EL NODO TRAINER I ELS PKMN
var party = [] setget ,get_party
export(bool)var is_trainer = true
var tilesVisibility



func _init(_Name, _battle_front_sprite, _battle_back_sprite, _before_battle_message, _init_battle_message, _end_battle_message, _is_defeated, _double_battle, _is_playable, _partner, _party, _is_trainer):
	Name = _Name
	battle_front_sprite = _battle_front_sprite
	battle_back_sprite = _battle_back_sprite
	before_battle_message = _before_battle_message
	init_battle_message = _init_battle_message
	end_battle_message = _end_battle_message
	is_defeated = _is_defeated
	double_battle = _double_battle
	is_playable = _is_playable
	partner = _partner
	party = _party
	is_trainer = _is_trainer
	
func is_type(type): return type == "Trainer" or .is_type(type)
func    get_type(): return "Trainer"

func has_pokemon(pk):
	for p in party:
		if p == pk:
			return true
	return false
	
func get_party():
	return party
	
func get_name():
	return Name

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
