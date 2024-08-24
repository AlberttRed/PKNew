class_name BattleMoveAilmentEffect extends BattleMoveEffect

#Effect que es crida cada turn quan un pokemon està cremat, paraltizar, confós etc per restat vida, comprovar si esta dormit...

var ailmentType : CONST.AILMENTS
var ailmentChance : int
var isStatusAilment : bool = false
var statusType : CONST.STATUS = CONST.STATUS.NONE

func _init(move:BattleMove):
	super._init(move)
	ailmentType = move.ailmentType
	ailmentChance = move.ailmentChance
	#target = move.pokemon


func applyPreviousEffects():
	pass
		#if ailment == CONST.AILMENTS.PARALYSIS:
			#randomize()
			#var valor : float = randf()
			#if valor <= (0.25):
				#target.canAttack = false
				#await target.battleSpot.playAnimation("PARALYSIS")
				#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)
#
		#if ailment == CONST.AILMENTS.CONFUSION:
			#pass
			#
		#if ailment == CONST.AILMENTS.SLEEP:
			#pass
			
#falta aplicar la resta de ailments previs

func applyLaterEffects():
	pass

	#if ailment == CONST.AILMENTS.POISON:
		#var value : int = int(target.hp_total / 8)
		#await target.take_damage(value)
		#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)
	#if ailment == CONST.AILMENTS.LEECH_SEED:
		##Drenadoras roba un 1/8 de la vida total de l'objectiu
		#var value : int = int(target.hp_total / 8)
		#await target.take_damage(value)
		#await pokemon.heal(value)
	#
		#await GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)

func calculateAilmentChance():
	randomize()
	var valor : float = randf()
	print("Trying " + move.pokemon.Name + " " + str(ailmentChance) + "% chance valor: " + str(valor))
	if valor <= (ailmentChance/100.0):
		return true
	return false
	
func showAilmentSuceededMessage():
	assert(false, "Please override showAilmentSuceededMessage()` in the derived script.")
	
func showAilmentRepeatedMessage():
	assert(false, "Please override showAilmentRepeatedMessage()` in the derived script.")

func showAilmentEffectMessage():
	assert(false, "Please override showAilmentEffectMessage()` in the derived script.")

func showAilmentEndMessage():
	assert(false, "Please override showAilmentEndMessage()` in the derived script.")
