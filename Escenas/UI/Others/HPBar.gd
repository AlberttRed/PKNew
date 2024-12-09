class_name HPBar extends Node2D

signal updated

var pokemon : BattlePokemon
@onready var healthBar = $health_bar
@onready var expBar
@onready var statusUI : Node2D = $Status

func init(_pokemon : BattlePokemon):
	pokemon = _pokemon
	
	healthBar.init(pokemon.instance)
	if has_node("exp_bar"):
		expBar = $exp_bar
		expBar.levelUP.connect(Callable(pokemon, "levelUP"))
		pokemon.updateEXP.connect(Callable(expBar,"on_exp_changes"))
		expBar.init(pokemon.instance)


func updateUI():
	get_node("lblName").setText(pokemon.Name)
	get_node("lblLevel").setText(str(pokemon.level))
	#hPBarNode.get_node("lblHP").setText(str(pokemonInstance.hp_actual) + "/" + str(pokemonInstance.hp_total)
	if pokemon.gender == CONST.GENEROS.HEMBRA:
		get_node("lblGender").setText("♀")
		get_node("lblGender").theme.set("Label/colors/font_color", Color("FF5D2C"))
	elif pokemon.gender == CONST.GENEROS.MACHO:
		get_node("lblGender").setText("♂")
		get_node("lblGender").theme.set("Label/colors/font_color", Color("3465DF"))#0.97254902124405, 0.34509804844856, 0.15686275064945))
	else:
		get_node("lblGender").setText("")
	
	updateStatusUI()
	healthBar.updateUI(pokemon.instance)
	if expBar!=null:
		expBar.updateUI(pokemon.instance)


	#$health_bar.init(pokemon)
	#get_node("health_bar").setHPBar(self)
	#if has_node("exp_bar"):
		#get_node("exp_bar").setExpBar(self)
	

func clearUI():
	get_node("lblName").setText("")
	get_node("lblLevel").setText("")
	get_node("lblGender").setText("")
	statusUI.hide()
	get_node("health_bar").clear()
	if has_node("exp_bar"):
		if pokemon.updateEXP.is_connected(Callable(get_node("exp_bar"), "on_exp_changes")):
			pokemon.updateEXP.disconnect(Callable(get_node("exp_bar"), "on_exp_changes"))
		if get_node("exp_bar").levelUP.is_connected(Callable(pokemon, "levelUP")):
			get_node("exp_bar").levelUP.disconnect(Callable(pokemon, "levelUP"))
		get_node("exp_bar").clear()

func updateStatusUI():
	if pokemon.status != CONST.STATUS.OK:
		statusUI.visible = true
		print(pokemon.status-1)
		statusUI.region_rect = Rect2(0, 16*(pokemon.status-1), 44, 16)
	else:
		statusUI.visible = false


func updateHP(hp: int):
	healthBar.updateHP(hp)
	await healthBar.updated
	updated.emit()
	
func updateEXP(exp):
	#while pokemon.totalExp < exp:
	var end:int = expBar.getValueEnd(exp)
	await expBar.animate_value(pokemon.totalExp, end)
	pokemon.totalExp = end
	if expBar.isNewLevel():
		#expBar.levelUP.emit()
		await pokemon.levelUP()
		#await pokemon.levelChanged
		print("AAAAAAAAAA" +str(pokemon.totalExp))
	updated.emit()	
	
#func updateEXP(exp: int):
	#await expBar.updateEXP(exp)
