class_name BattleEffect

signal finished

static func getAilment(ailmentCode : Ailments) -> Resource:
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Ailments/"+Ailments.keys()[ailmentCode+1]+".gd"):
		return load("res://Scripts/Batalla/Effects/Ailments/"+Ailments.keys()[ailmentCode+1]+".gd")
	return null
	
static func getAbility(abilityCode : Abilities) -> Resource:
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Abilities/"+Abilities.keys()[abilityCode]+".gd"):
		return load("res://Scripts/Batalla/Effects/Abilities/"+Abilities.keys()[abilityCode]+".gd")
	return null

static func getMove(moveCode : Moves) -> Resource:
	if Moves.keys().size() < moveCode:
		return null
	if FileAccess.file_exists("res://Scripts/Batalla/Effects/Moves/"+Moves.keys()[moveCode]+".gd"):
		return load("res://Scripts/Batalla/Effects/Moves/"+Moves.keys()[moveCode]+".gd")
	return null

#enum List {
	#PARALYSIS,
	#BURN,
	#SLEEP,
	#FREEZE,
	#POISON,
	#VELO_AURORA,
	#PANTALLA_LUZ,
	#REFLEJO,
	#ALLANAMIENTO
#}

enum Moves {
	REFLECT = 115,
	CONFUSE_RAY = 109,
	FACADE = 263
}

enum Ailments {
	UNKNOWN = -1,
	NONE = 0, 
	PARALYSIS = 1,
	SLEEP = 2,
	FREEZE = 3,
	BURN = 4,
	POISON = 5,
	CONFUSION = 6,
	INFATUATION = 7,
	TRAP = 8,
	NIGHTMARE = 9,
	TORMENT = 12,
	DISABLE = 13,
	YAWN = 14,
	HEAL_BLOCK = 16,
	NO_TYPE_IMMUNITY = 17,
	LEECH_SEED = 18,
	EMBARGO = 19,
	PERISH_SONG = 20,
	INGRAIN = 21
}

enum Abilities {
	NONE,
	HEDOR,
	LLOVIZNA,
	IMPULSO,
	ARMADURA_BATALLA,
	ROBUSTEZ,
	HUMEDAD,
	FLEXIBILIDAD,
	VELO_ARENA,
	ELEC_ESTATICA,
	ABSORBE_ELEC,
	ABSORBE_AGUA,
	DESPISTE,
	ACLIMATACION,
	OJO_COMPUESTO,
	INSOMNIO,
	CAMBIO_COLOR,
	INMUNIDAD,
	ABSORBE_FUEGO,
	POLVO_ESCUDO,
	RITMO_PROPIO,
	VENTOSAS,
	INTIMIDATE, #INTIMIDACION
	SOMBRA_TRAMPA,
	PIEL_TOSCA,
	SUPERGUARDA,
	LEVITACION,
	EFECTO_ESPORA,
	SINCRONIA,
	CUERPO_PURO,
	CURA_NATURAL,
	PARARRAYOS,
	DICHA,
	NADO_RAPIDO,
	CLOROFILA,
	ILUMINACION,
	RASTRO,
	POTENCIA,
	PUNTO_TOXICO,
	FOCO_INTERNO,
	ESCUDO_MAGMA,
	VELO_AGUA,
	IMAN,
	INSONORIZAR,
	CURA_LLUVIA,
	CHORRO_ARENA,
	PRESION,
	SEBO,
	MADRUGAR,
	CUERPO_LLAMA,
	RUN_AWAY,#FUGA,
	VISTA_LINCE,
	CORTE_FUERTE,
	RECOGIDA,
	AUSENTE,
	ENTUSIASMO,
	GRAN_ENCANTO,
	MAS,
	MENOS,
	PREDICCION,
	VISCOSIDAD,
	MUDAR,
	GUTS, #AGALLAS,
	ESCAMA_ESPECIAL,
	LODO_LIQUIDO,
	OVERGROW, #ESPESURA,
	MAR_LLAMAS,
	TORRENTE,
	ENJAMBRE,
	CABEZA_ROCA,
	SEQUIA,
	TRAMPA_ARENA,
	ESPIRITU_VITAL,
	HUMO_BLANCO,
	ENERGIA_PURA,
	CAPARAZON,
	BUCLE_AIRE,
	TUMBOS,
	ELECTROMOTOR,
	RIVALIDAD,
	IMPASIBLE,
	MANTO_NIVEO,
	GULA,
	IRASCIBLE,
	LIVIANO,
	HEATPROOF, #IGNIFUGO,
	SIMPLE,
	PIEL_SECA,
	DESCARGA,
	PUNO_FERREO,
	ANTIDOTO,
	ADAPTABLE,
	ENCADENADO,
	HIDRATACION,
	PODER_SOLAR,
	PIES_RAPIDOS,
	NORMALIDAD,
	FRANCOTIRADOR,
	MURO_MAGICO,
	INDEFENSO,
	REZAGADO,
	EXPERTO,
	DEFENSA_HOJA,
	ZOQUETE,
	ROMPEMOLDES,
	AFORTUNADO,
	RESQUICIO,
	ANTICIPACION,
	ALERTA,
	IGNORANTE,
	CROMOLENTE,
	FILTRO,
	INICIO_LENTO,
	INTREPIDO,
	COLECTOR,
	GELIDO,
	ROCA_SOLIDA,
	NEVADA,
	RECOGEMIEL,
	CACHEO,
	AUDAZ,
	MULTITIPO,
	DON_FLORAL,
	MAL_SUENO,
	HURTO,
	POTENCIA_BRUTA,
	RESPONDON,
	NERVIOSISMO,
	COMPETITIVO,
	FLAQUEZA,
	CUERPO_MALDITO,
	ALMA_CURA,
	COMPIESCOLTA,
	ARMADURA_FRAGIL,
	METAL_PESADO,
	METAL_LIVIANO,
	COMPENSACION,
	IMPETU_TOXICO,
	IMPETU_ARDIENTE,
	COSECHA,
	TELEPATIA,
	VELETA,
	FUNDA,
	TOQUE_TOXICO,
	REGENERACION,
	SACAPECHO,
	IMPETU_ARENA,
	PIEL_MILAGRO,
	CALCULO_FINAL,
	ILUSION,
	IMPOSTOR,
	ALLANAMIENTO,
	MOMIA,
	AUTOESTIMA,
	JUSTICIERO,
	COBARDIA,
	ESPEJO_MAGICO,
	HERBIVORO,
	BROMISTA,
	PODER_ARENA,
	PUNTA_ACERO,
	MODO_DARUMA,
	TINOVICTORIA,
	TURBOLLAMA,
	TERRAVOLTAJE,
	VELO_AROMA,
	VELO_FLOR,
	CARRILLO,
	MUTATIPO,
	PELAJE_RECIO,
	PRESTIDIGITADOR,
	ANTIBALAS,
	TENACIDAD,
	MANDIBULA_FUERTE,
	PIEL_HELADA,
	VELO_DULCE,
	CAMBIO_TACTICO,
	ALAS_VENDAVAL,
	MEGADISPARADOR,
	MANTO_FRONDOSO,
	SIMBIOSIS,
	GARRA_DURA,
	PIEL_FEERICA,
	BABA,
	PIEL_CELESTE,
	AMOR_FILIAL,
	AURA_OSCURA,
	AURA_FEERICA,
	ROMPEAURA,
	MAR_DEL_ALBOR,
	TIERRA_DEL_OCASO,
	RAFAGA_DELTA,
	FIRMEZA,
	HUIDA,
	RETIRADA,
	HIDRORREFUERZO,
	ENSANAMIENTO,
	ESCUDO_LIMITADO,
	VIGILANTE,
	POMPA,
	ACERO_TEMPLADO,
	COLERA,
	QUITANIEVES,
	REMOTO,
	VOZ_FLUIDA,
	PRIMER_AUXILIO,
	PIEL_ELECTRICA,
	COLA_SURF,
	BANCO,
	DISFRAZ,
	FUERTE_AFECTO,
	AGRUPAMIENTO,
	CORROSION,
	LETARGO_PERENNE,
	REGIA_PRESENCIA,
	REVES,
	PAREJA_DE_BAILE,
	BATERIA,
	PELUCHE,
	CUERPO_VIVIDO,
	CORANIMA,
	RIZOS_REBELDES,
	RECEPTOR,
	REACCION_QUIMICA,
	ULTRAIMPULSO,
	SISTEMA_ALFA,
	ELECTROGENESIS,
	PSICOGENESIS,
	NEBULOGENESIS,
	HERBOGENESIS,
	GUARDIA_METALICA,
	GUARDIA_ESPECTRO,
	ARMADURA_PRISMA
}

enum Type {
	MOVE,
	STATUS,
	AILMENT,
	ABILITY,
	WEATHER	
}

enum Priority {
	LOWEST,
	LOW,
	MIDDLE,
	HIGH,
	HIGHEST
}

var originPokemon : BattlePokemon
var targetPokemon : BattlePokemon
var priority : Priority:
	get:
		return getPriority()
var targetField : BattleField
var effectChance : int
var effectHits : bool #Indicate if the effect/move misses or not
#var _origin = null # BattleMove | Abilty, Ailment


var pokemon : BattlePokemon
var persistent:bool:
	get:
		return getPersistent()
	#get:
		#return maxTurns == 0 and minTurns == 0

var minTurns:int = 0:
	set(min):
		if min == null:
			min = 0
		turnsCounter = 0
		minTurns = min
var maxTurns :int = 0:
	set(max):
		if max == null:
			max = 0
		turnsCounter = 0
		maxTurns = max

var turnsCounter:int
var activeTurns:int

func _init(_origin = null, _target = null):
	setOrigin(_origin)
	setTarget(_target)

func setOrigin(_origin):
	if _origin == null:
		return
	if _origin is BattleMove:
		self.originPokemon = _origin.pokemon
	elif _origin is BattlePokemon:
		self.originPokemon = _origin
	else:
		assert(false, "Not a valid origin type for BattleEffect " + str(self.name))

func setOriginPokemon(_pokemon:BattlePokemon):
	self.originPokemon = _pokemon
	
func setTarget(_target):
	if _target == null:
		return
	if _target is BattleField:
		self.targetField = _target
	elif _target is BattlePokemon:
		self.targetPokemon = _target
	elif _target is BattleSpot:
		self.targetPokemon = _target.activePokemon
	else:
		assert(false, "Not a valid target type for BattleEffect " + str(self.name))
		return
	effectHits = checkHitEffect()

func getPriority() -> int:
	if self.type == Type.STATUS:
		return Priority.HIGH
	else:
		return Priority.LOWEST

func getPersistent() -> bool:
	return false
	
	
func doEffect():
	assert(false, "Please override doEffect()` in the derived script.")

func checkHitEffect() -> bool:
	return true


func clear():
	pass

func calculateTurns():
	randomize()
	turnsCounter=0
	activeTurns = randi_range(minTurns,maxTurns)

func nextTurn():
	turnsCounter += 1
	return turnsCounter <= activeTurns

func calculateEffectChance():
	randomize()
	var valor : float = randf()
	#print("Trying " + move.pokemon.Name + " " + str(ailmentChance) + "% chance valor: " + str(valor))
	if valor <= (effectChance/100.0):
		return true
	return false
	
#region New Code Region
	
func applyBattleEffectAtInitBattleTurn():
	pass
	
func applyBattleEffectAtEndBattleTurn():
	pass

func applyBattleEffectAtInitPKMNTurn():
	pass
	
func applyBattleEffectAtEndPKMNTurn():
	pass

func applyBattleEffectAtCalculateDamage():
	pass
	
func applyBattleEffectAtTakeDamage():
	pass

func applyBattleEffectAtEscapeBattle():
	pass
	
func applyBattleEffectAtBeforeMove():
	pass
	
func applyBattleEffectAtAfterMove():
	pass
#endregion

func showEffectSuceededMessage():
	assert(false, "Please override showEffectSuceededMessage()` in the derived script.")
	
func showEffectRepeatedMessage():
	assert(false, "Please override showEffectRepeatedMessage()` in the derived script.")

func showEffectMessage():
	assert(false, "Please override showEffectMessage()` in the derived script.")

func showEffectEndMessage():
	assert(false, "Please override showEffectEndMessage()` in the derived script.")


#Get the name of the script(without .gd) as the name
func _get(property: StringName) -> Variant:
	if property == "name":
		return 	get_script().get_path().get_file().trim_suffix('.gd')
	if property == "type":
		var array = get_script().get_path().split("/")
		array.reverse()
		var typeName = array[1]
		match typeName:
			"Abilities":
				return Type.ABILITY
			"Ailments":
				var effectName = self.name
				if effectName == "PARALYSIS" || effectName == "BURN" || effectName == "SLEEP" || effectName == "FREEZE" || effectName == "POISON":
					return Type.STATUS
				return Type.AILMENT
			"Moves":
				return Type.MOVE
			_:
				return null
	return property
	
#
#func setOrigin(origin):
	#if origin is BattleMove:
		#pass
#
	#
#func setTarget(target):
	#if target is BattlePokemon:
		#pass
	#elif target is BattleSide:
		#pass
#
#func doAnimation():
#	assert(false, "Please override doAnimation()` in the derived script.")
#
#
#func moveInflictsDamage():
#	return move.moveInflictsDamage()
#
#func moveModifyStats():
#	return move.moveModifyStats()
#
#func moveCausesAilment():
#	return move.moveCausesAilment()
