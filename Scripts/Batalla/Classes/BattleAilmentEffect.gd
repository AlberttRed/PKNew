class_name BattleAilmentEffect

#Effect que es crida cada turn quan un pokemon està cremat, paraltizar, confós etc per restat vida, comprovar si esta dormit...

var ailmentType : CONST.AILMENTS
var ailmentChance : int
var isStatusAilment : bool = false
var statusType : CONST.STATUS = CONST.STATUS.NONE

static func getAilment(ailmentCode : CONST.AILMENTS) -> Resource:
	if ailmentCode == null:
		return null
	if FileAccess.file_exists("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentCode+1]+".gd"):
		return load("res://Scripts/Batalla/Ailments/"+CONST.AILMENTS.keys()[ailmentCode+1]+".gd")
	return null

##func _init():
	#super._init(move)
	#ailmentType = move.ailmentType
	#ailmentChance = move.ailmentChance
	#minTurns = move.min_turns
	#maxTurns =  move.max_turns
	#target = move.pokemon


func applyPreviousEffects():
	pass

func applyLaterEffects():
	pass

#func calculateAilmentChance():
	#randomize()
	#var valor : float = randf()
	##print("Trying " + move.pokemon.Name + " " + str(ailmentChance) + "% chance valor: " + str(valor))
	#if valor <= (ailmentChance/100.0):
		#return true
	#return false
	
#func showAilmentSuceededMessage():
	#assert(false, "Please override showAilmentSuceededMessage()` in the derived script.")
	#
#func showAilmentRepeatedMessage():
	#assert(false, "Please override showAilmentRepeatedMessage()` in the derived script.")
#
#func showAilmentEffectMessage():
	#assert(false, "Please override showAilmentEffectMessage()` in the derived script.")
#
#func showAilmentEndMessage():
	#assert(false, "Please override showAilmentEndMessage()` in the derived script.")
