extends BattleCommonAnimation
#----------------------------------------------------
#	Animació que llança la pokeball de l'entrenador per treure el pokémon
#----------------------------------------------------
const animName = "General/BATTLE_TRANSITION_GRASS"
var leafImagePath = "res://Sprites/Pictures/TallGrassLeafBattle.png"

var spr_BackTransition:Sprite2D
var spr_Grass1:Sprite2D
var spr_Grass2:Sprite2D
var spr_Leaves:Array[Sprite2D] = []
var blackPanel:Panel

func setAnimation(_root, animParams:Dictionary):#_init():
	root = _root
	#var pkmnName:StringName = animParams.get('PokemonName')
	
#	Panel blackPanel
	blackPanel = Panel.new()
	blackPanel.name = "blackPanel"
	blackPanel.z_index = 14
	blackPanel.size = Vector2(512,96)
	blackPanel.position = Vector2(0,288)
	var styleBox:StyleBoxTexture = StyleBoxTexture.new()
	var canvasTexture:CanvasTexture = CanvasTexture.new()
	canvasTexture.specular_color = Color.BLACK
	styleBox.texture = canvasTexture
	#blackPanel.panel = styleBox
	blackPanel.add_theme_stylebox_override("panel", styleBox)
	root.add_child(blackPanel)
	
#	Sprite BackTransition
	spr_BackTransition = Sprite2D.new()
	spr_BackTransition.name = "BackTransition"
	spr_BackTransition.z_index = 12
	root.add_child(spr_BackTransition)
	
#	Sprite Grass1
	spr_Grass1 = Sprite2D.new()
	spr_Grass1.name = "Grass1"
	spr_Grass1.z_index = 14
	root.add_child(spr_Grass1)
	
#	Sprite Grass2
	spr_Grass2 = Sprite2D.new()
	spr_Grass2.name = "Grass2"
	spr_Grass2.z_index = 14
	root.add_child(spr_Grass2)
	
	for i in range(8):
		createLeafSprite()

func createLeafSprite() -> Sprite2D:
	var sprLeaf: Sprite2D = Sprite2D.new()
	spr_Leaves.push_back(sprLeaf)
	sprLeaf.name = "Leaf" + str(spr_Leaves.size())
	sprLeaf.z_index = 13
	sprLeaf.texture = load(leafImagePath)
	var scale = randf_range(0.25,0.50)
	sprLeaf.scale = Vector2(scale,scale)
	root.add_child(sprLeaf)
	#sprLeaf.visible = true
	
	var track_index 
	var initVal 
	var finalVal
	var battlePath
	# position
	battlePath = sprLeaf.name+":position"
	if find_track(battlePath, Animation.TYPE_VALUE) == -1:
		track_index = add_track(Animation.TYPE_VALUE)
		track_set_path(track_index, battlePath)
		initVal = Vector2(randi_range(263,291),randi_range(158,179))
		finalVal = Vector2(randi_range(176,370),randi_range(50,113))
		track_insert_key(track_index, 0.85, initVal)
		track_insert_key(track_index, 1.85, finalVal)

	# rotation
	battlePath = sprLeaf.name+":rotation"
	if find_track(battlePath, Animation.TYPE_VALUE) == -1:
		track_index = add_track(Animation.TYPE_VALUE)
		track_set_path(track_index, battlePath)
		initVal = randi_range(0,360)
		finalVal = randi_range(initVal-10,initVal+10)
		track_insert_key(track_index, 1.06, initVal)
		track_insert_key(track_index, 1.85, finalVal)

	# modulate
	battlePath = sprLeaf.name+":modulate"
	if find_track(battlePath, Animation.TYPE_VALUE) == -1:
		track_index = add_track(Animation.TYPE_VALUE)
		track_set_path(track_index, battlePath)
		initVal = Color("ffffff")
		finalVal = Color("ffffff00")
		track_insert_key(track_index, 0.00, finalVal)
		track_insert_key(track_index, 1.39, finalVal)
		track_insert_key(track_index, 1.40, initVal)
		track_insert_key(track_index, 1.86, finalVal)
	
	return sprLeaf

func freeAnimation():
	blackPanel.queue_free()
	spr_BackTransition.queue_free()
	spr_Grass1.queue_free()
	spr_Grass2.queue_free()
	for sprLeaf:Sprite2D in spr_Leaves:
		sprLeaf.queue_free()
	spr_Leaves.clear()
