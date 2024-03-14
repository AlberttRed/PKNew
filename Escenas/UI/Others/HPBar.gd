extends Node2D

signal updated

var pokemon : BattlePokemon
@onready var healthBar = $health_bar
@onready var expBar
@onready var statusUI : Node2D = $Status

func init(_pokemon : BattlePokemon):
	pokemon = _pokemon
	healthBar.init(pokemon)
	if has_node("exp_bar"):
		expBar = $exp_bar
		expBar.init(pokemon)


func updateUI():
	get_node("Name/lblName").text = pokemon.Name
	get_node("lblLevel").text = "Nv" + str(pokemon.level)
	#hPBarNode.get_node("lblHP").text = str(pokemonInstance.hp_actual) + "/" + str(pokemonInstance.hp_total)
	if pokemon.gender == CONST.GENEROS.HEMBRA:
		get_node("Name/lblGender").text = "♀"
		get_node("Name/lblGender").set("Label/colors/font_color", Color(0.97254902124405, 0.34509804844856, 0.15686275064945))
	elif pokemon.gender == CONST.GENEROS.MACHO:
		get_node("Name/lblGender").text = "♂"
		get_node("Name/lblGender").set("Label/colors/font_color", Color(0.18823529779911, 0.37647059559822, 0.84705883264542))
	
	else:
		get_node("Name/lblGender").text = ""
	
	updateStatusUI()
	healthBar.updateUI(pokemon)
	if expBar!=null:
		expBar.updateUI(pokemon)


	#$health_bar.init(pokemon)
	#get_node("health_bar").setHPBar(self)
	#if has_node("exp_bar"):
		#get_node("exp_bar").setExpBar(self)
	

func clearUI():
	get_node("Name/lblName").text = ""
	get_node("lblLevel").text = ""
	get_node("Name/lblGender").text = ""
	statusUI.hide()
	get_node("health_bar").clear(self)


func updateStatusUI():
	if pokemon.status != CONST.STATUS.OK:
		statusUI.visible = true
		statusUI.region_rect = Rect2(0, 16*(pokemon.status-1), 44, 16)
	else:
		statusUI.visible = false


func updateHP(hp: int):
	healthBar.updateHP(hp)
	await healthBar.updated
	updated.emit()
	
func updateEXP(exp):
	while pokemon.totalExp < exp:
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
