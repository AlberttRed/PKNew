extends BattleCommonAnimation
#----------------------------------------------------
#	Animació que llança la pokeball de l'entrenador per treure el pokémon
#----------------------------------------------------
const animName = "General/SELECT_ACTION"
var track_index

func setAnimation(_root, animParams:Dictionary):#_init():
	root = _root
	var hpBar:HPBar = root.HPbar#animParams.get('HPBar')
	var barPosition = Vector2(0,0)
	var battlePath = root.get_path_to(hpBar)
	if hpBar.name.contains("A"):
		barPosition = CONST.BATTLE.SINGLE_PLAYERHPBAR_A_FINALPOSITION
	else:
		pass
	if track_index == null:
		track_index = add_track(Animation.TYPE_VALUE)
		track_set_path(track_index, str(battlePath)+":position")
		track_insert_key(track_index, 0.0, barPosition)
		track_insert_key(track_index, 0.3, barPosition+Vector2(0,-4))

func freeAnimation():
	pass
