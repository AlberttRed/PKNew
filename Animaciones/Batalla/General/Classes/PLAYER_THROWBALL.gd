extends BattleCommonAnimation
#----------------------------------------------------
#	Animació que llança la pokeball de l'entrenador per treure el pokémon
#----------------------------------------------------
const animName = "General/PLAYER_THROWBALL"
var spr1:Sprite2D
var track_index
var key_id

func setAnimation(_root, animParams:Dictionary):#_init():
	root = _root
	var pkmnName:StringName = animParams.get('PokemonName')
		
	spr1 = Sprite2D.new()
	spr1.name = "Pokeball"
	
	# ShowMessage
	track_index = add_track(Animation.TYPE_METHOD)
	var battlePath = root.get_path_to(GUI.battle)
	track_set_path(track_index, battlePath)
	#track_insert_key(track_index, 0.2, {"method": "showMessage","args": ["¡Adelante " + pkmnName + "!", false, 0.5, false]})
	key_id = track_insert_key(track_index, 0.2, {"method": "showMessageWait","args": ["¡Adelante " + pkmnName + "!",  0.5]})

	root.add_child(spr1)

func freeAnimation():
	spr1.queue_free()
	track_remove_key(track_index, key_id)
