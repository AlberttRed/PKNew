class_name BattleAilmentEffect extends BattleEffect

#Effect que es crida cada turn quan un pokemon està cremat, paraltizar, confós etc per restat vida, comprovar si esta dormit...

var ailment : CONST.AILMENTS
var target : BattlePokemon

func _init(_isStatus : bool, _ailment : CONST.AILMENTS, _pokemon : BattlePokemon, _target : BattlePokemon):
	super._init(_pokemon, _isStatus)
	ailment = _ailment
	target = _target

func doAnimation():
	assert(false, "Please override doAnimation()` in the derived script.")
	
func applyPreviousEffects():
		if ailment == CONST.AILMENTS.PARALYSIS:
			randomize()
			var valor : float = randf()
			if valor <= (0.25):
				target.canAttack = false
				await BattleAnimationList.new().getAilmentAnimation(ailment).doAnimation(target)
				GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)
				await GUI.battle.msgBox.finished

		if ailment == CONST.AILMENTS.CONFUSION:
			pass
			
		if ailment == CONST.AILMENTS.SLEEP:
			pass
			
#falta aplicar la resta de ailments previs

func applyLaterEffects():
	

	if ailment == CONST.AILMENTS.POISON:
		var value : int = int(target.hp_total / 8)
		await target.take_damage(value)
		GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)
		await GUI.battle.msgBox.finished
	if ailment == CONST.AILMENTS.LEECH_SEED:
		#Drenadoras roba un 1/8 de la vida total de l'objectiu
		var value : int = int(target.hp_total / 8)
		await target.take_damage(value)
		await pokemon.heal(value)
	
		GUI.battle.msgBox.showAilmentMessage_Effect(target, ailment)
		await GUI.battle.msgBox.finished
