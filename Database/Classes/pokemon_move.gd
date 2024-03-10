extends Node

#var MOVE_FUNCTIONS = load("res://Assets/ui/battle/BATTLE_MoveFunctions.gd").INST()
#var MOVE_ANIMATIONS = load("res://Assets/ui/battle/BATTLE_MoveAnimations.gd").new()

@export var internal_name : String = ""
@export var Name : String = "" # the resource name e.g. Overgrow.
@export var id : int = 0 # the id of the resource.
@export_multiline var description : String = "" # a description of the move.
@export_enum("None", "Normal", "Fighting", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost", "Steel", "Fire", "Water", "Grass", "Electric", "Psychic", "Ice", "Dragon", "Dark", "Fairy") var type = 1
#@export_enum("None, Normal, Fighting, Flying, Poison, Ground, Rock, Bug, Ghost, Steel, Fire, Water, Grass, Electric, Psychic, Ice, Dragon, Dark, Fairy") var type = 1
@export var power : int = 0 # the power of the move.
@export var accuracy : int = 0 # the accuracy of the move.
@export var pp : int = 0 # the pp points of the move.
@export var effect_chance : int # % de que un atac pugui produir un problema d estat(cremar, confuso etc)
@export var priority : int = 0 # % de que un atac pugui produir un problema d estat(cremar, confuso etc)
@export_enum("None", "Estado", "Físico", "Especial") var damage_class_id = 0 # % de que un atac pugui produir un problema d estat(cremar, confuso etc)
@export_multiline var effect_entries : String = "" # Explicacio de com es produeix l atac. Ho faré servir per quan fagi els scripts dels atacs
@export var stat_change_ids : Array = [] # id de l'estat que es modifica
@export var stat_change_valors : Array = [] #numero de stages que baixa o puja l stat (-2 = baixa dos stages)
@export var target_id : int = 1 # la id del target de l atac. Si ataca al rival, o pot atacar a dos a lhora, o a un aliat, o a tots els q hi ha en combat...
@export var meta_ailment_id : int # la id del tipus de ailment que pot provocar el mov.(cremar, paralitzar etc)
@export var meta_category_id : int = 1 # la id de l'"efecte" que provoca el moviment. si fa mal, si fa mal i pot cremar, si cura etc.
@export var meta_min_hits : int = 1 #numero minim de cops q fa l atac en un turn. si només fa un és null
@export var meta_max_hits : int = 1 #numero maxim de cops q fa l atac en un turn. si només fa un és null
@export var meta_min_turns : int = 1 #numero minim de truns q dura o es repeteix l atac. si només dura un és null
@export var meta_max_turns : int = 1 #numero maxim de truns q dura o es repeteix l atac. si només dura un és null
@export var meta_drain : int = 0 #numero de ps que et cura o et treu l atac. (drenadoras cura, per tant sera valor positiu, si estas enverinat et treu, per tant sera valor negatiu)
@export var meta_healing : int = 0 # % de vida que es cura l atacant fent el mov. segons el seu total de ps
@export var meta_crit_rate : int = 0 # ratio de que l atac pugui provocar un cop critic
@export var meta_ailment_chance : int = 0 # % de que el mov. provoqui ailment
@export var meta_flinch_chance : int = 0 # % de que un atac fagi retrocedir  al rival
@export var meta_stat_chance : int = 0 # % de que un atac pugi o baixi els stats
@export var contact_flag : bool = false
@export var move_effect : int = 1 #id de la funció que s'ocupa de calcular el mal d'aquest moviment
#var functions = MOVE_FUNCTIONS.hola()


func _init():
	add_user_signal("move_done")
	add_user_signal("animation_done")
#
#func get_name():
#	return DB.moves[id].Name
##
#func doMove(move,from,to):
##	var ran = 0.85
##	var damages = ""
##	while ran < 1.01:
##		damages = damages + str(get_damage(from,to,ran)) + ", "
##		ran = ran + 0.01
##	print(damages)
#	MOVE_FUNCTIONS.functions["Move_Function" + str(self.move_effect).pad_zeros(3)].new().ApplyDamage(move,from,to)
#	yield(MOVE_FUNCTIONS.functions["Move_Function" + str(self.move_effect).pad_zeros(3)].new(), "move_done")
#
#	emit_signal("move_done")
#
#func ShowAnimation(from,to):	
#	MOVE_ANIMATIONS.animations["Move_Animation" + str(self.move_effect).pad_zeros(3)].new().ShowAnimation(from,to)
#	yield(MOVE_ANIMATIONS.animations["Move_Animation" + str(self.move_effect).pad_zeros(3)].new(), "animation_done")
#	emit_signal("animation_done")
#
func is_special():
	return damage_class_id == CONST.DAMAGE_CLASS.ESPECIAL
	
func has_target(target):
	return target_id == target
	
func has_multiple_targets(from):
	if from.listEnemies.size() == 2:
		if has_target(CONST.TARGETS.BASE_ENEMY) or has_target(CONST.TARGETS.ALL_OTHER) or has_target(CONST.TARGETS.ENEMIES) or has_target(CONST.TARGETS.ALL_FIELD) or has_target(CONST.TARGETS.ALL_POKEMON) or has_target(CONST.TARGETS.PLAYERS) or has_target(CONST.TARGETS.BASE_PLAYER):
			return true
		else:
			return false
	else:
		return false
		
func is_type(t):
	return type == t
	
func hasWorkingMoveEffect(e):
	return move_effect == e
	
func makeContact():
	return contact_flag

func get_pp():
	return pp
#
#func get_damage(from,to,r = null):
#	var Damage
#	#var Modifier
#	var Att = from.get_attack()
#	var Def = to.get_defense()
#	var STAB = 1.0
#	var Ef = DB.types[self.type].get_effectiveness_against(to.get_type1())
#	var random
#	var Targets = 1.0
#	var Weather = 1.0
#	var Critical = 1.0 # TO DO
#	var Burn = 1.0
#	var Other = 1.0
#	if self.is_special():
#		Att = from.get_special_attack()
#		Def = to.get_special_defense()
#
#	if self.has_multiple_targets(from):
#		Targets = 0.75
#
#	if GUI.battle.hasWorkingWeather(CONST.WEATHER.LLUVIOSO):
#		if self.is_type(CONST.TYPES.FUEGO):
#			Weather = 0.5
#		elif self.is_type(CONST.TYPES.AGUA):
#			Weather = 1.5
#	elif GUI.battle.hasWorkingWeather(CONST.WEATHER.SOLEADO):
#		if self.is_type(CONST.TYPES.FUEGO):
#			Weather = 1.5
#		elif self.is_type(CONST.TYPES.AGUA):
#			Weather = 0.5
#
#	if from.get_types().has(type) and from.hasWorkingAbiltity(CONST.ABILITIES.ADAPTABLE):
#		STAB = 2
#	elif from.get_types().has(type) and !from.hasWorkingAbiltity(CONST.ABILITIES.ADAPTABLE):
#		STAB = 1.5
#
#	if from.is_status(CONST.STATUS.BURNT) and !from.hasWorkingAbiltity(CONST.ABILITIES.AGALLAS) and (!self.is_special() and self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.IMAGEN)):
#		Burn = 0.5
#
#	if to.get_type2() != CONST.TYPES.NONE:
#		Ef = Ef * DB.types[type].get_effectiveness_against(to.get_type2())
#
#	if r == null:
#		randomize()
#		random = 1.0#rand_range(0.85, 1.01)
#	else:
#		random = r
#
#	Other = calculate_others(from,to,Ef,false)
#
#	Damage = int(int((int((2.0 * float(from.level))/5.0 + 2.0) * float(power) * float(Att))/float(Def))/50.0 + 2.0) #(((2 * from.level/5 + 2) * power * Att/Def)/50 + 2)
#	#print("Level: " + str(from.level) + ", Power: " + str(power) + ", Attack: " + str(Att) + ", Def: " + str(Def))
#
#	#print("Targets: " + str(Targets) + ", Weather: " + str(Weather) + ", Critical: " + str(Critical) + ", Random: " + str(random) + ", STAB: " + str(STAB) + ", Ef: " + str(Ef) + ", Burn: " + str(Burn) + ", Other: " + str(Other))
#	var result = int(int(int(int(int(int(int(int(Damage*Targets) * Weather) * Critical) * random) * STAB) * Ef) * Burn) * Other)
#
#	if result == 0:
#		result = 1
#	return result
#
#func calculate_others(from,to,Type,critical):
#	var value = 1.0
#
#	### MOVES
#	if to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and !critical and !from.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
#		value *= 0.5
#
#	if (self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.GOLPE_CUERPO) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.CARGA_DRAGON) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.CUERPO_PESADO) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.PLANCHA_VOLADORA) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.GOLPE_CALOR) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.PISOTON)) and to.hasWorkingEffect(CONST.MOVE_EFFECTS.REDUCCION):
#		value *= 2.0
#
#	if (self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.TERREMOTO) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.MAGNITUD)) and to.hasWorkingEffect(CONST.MOVE_EFFECTS.EXCAVAR):
#		value *= 2.0
#
#	if (self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.SURF) or self.hasWorkingMoveEffect(CONST.MOVE_EFFECTS.TORBELLINO)) and to.hasWorkingEffect(CONST.MOVE_EFFECTS.BUCEO):
#		value *= 2.0
#
#	if !to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.PANTALLA_LUZ) and !critical and !from.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
#		value *= 0.5
#
#	if !to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.VELO_AURORA) and to.base.hasWorkingFieldEffect(CONST.MOVE_EFFECTS.REFLEJO) and !critical and !from.hasWorkingAbility(CONST.MOVE_EFFECTS.ALLANAMIENTO):
#		value *= 0.5
#
#	### ABILITIES
#
#	if to.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and self.makeContact() and !self.is_type(CONST.TYPES.FUEGO):
#		value *= 0.5
#	elif to.hasWorkingAbility(CONST.ABILITIES.PELUCHE) and !self.makeContact() and self.is_type(CONST.TYPES.FUEGO):
#		value *= 2.0
#
#	if to.hasWorkingAbility(CONST.ABILITIES.FILTRO) and Type > 1:
#		value *= 0.75
#
#	if from.hasAlly() and from.ally.hasWorkingAbility(CONST.ABILITIES.COMPIESCOLTA):
#		value *= 0.75
#
#	if to.hasWorkingAbility(CONST.ABILITIES.COMPENSACION) and to.hasFullHealth():
#		value *= 0.50
#
#	if to.hasWorkingAbility(CONST.ABILITIES.ARMADURA_PRISMA) and Type > 1:
#		value *= 0.75
#
#	if to.hasWorkingAbility(CONST.ABILITIES.GUARDIA_ESPECTRO) and to.hasFullHealth():
#		value *= 0.50
#
#	if from.hasWorkingAbility(CONST.ABILITIES.FRANCOTIRADOR) and critical:
#		value *= 1.50
#
#	if to.hasWorkingAbility(CONST.ABILITIES.ROCA_SOLIDA) and Type > 1:
#		value *= 0.75
#
#	if from.hasWorkingAbility(CONST.ABILITIES.CROMOLENTE) and Type < 1:
#		value *= 2.0
#
#	return value
	### ITEMS
	
