class_name BattleMessageController


signal textDisplayed
signal finished
signal accept

var msgBox : MessageBox = null

var text_completed = false :
	get:
		return msgBox.text_completed

var msg:
	set(v):
		msg = v



#func _init(_panel : Panel):
	#msgBox = MessageBox.new(_panel)
	#accept.connect(Callable(self, "accept_msg"))
	#msgBox.textDisplayed.connect(Callable(self, "msg_TextDisplayed"))
	#msgBox.finished.connect(Callable(self, "msg_Finished"))

#Missatge que es mostra quan un atac es efectiu, ho es poc, o no afecta
func showEffectivnessMessage(_target : BattlePokemon, _STAB : int):
	if _STAB >= 2:
		await GUI.battle.showMessageWait("¡Es muy efectivo!", 2.0)
		#await GUI.battle.msgBox.finished
	elif _STAB < 1:
		await GUI.battle.showMessageWait("No parece muy efectivo...", 2.0)
		#await GUI.battle.msgBox.finished
	elif _STAB == 0:
		await GUI.battle.showMessageWait("No afecta " + _target.battleMessageMiddleAlName + ".", 2.0)
		#await GUI.battle.msgBox.finished


#Missatge que es mostra quan es realitza un atac
func showMoveMessage(_user : BattlePokemon, _move : BattleMove):
	var type = ""
	#if _user.controllable:
		#await GUI.battle.showMessage("¡" + _user.Name + " ha usado " + _move.Name + "!", false, 0.5)
	#else:
		#if GUI.battle.controller.rules.type == CONST.BATTLER_TYPES.TRAINER:
			#type = " enemigo"
		#else:
			#type = " salvaje"
	await GUI.battle.showMessageWait("¡" + _user.battleMessageInitialName + " ha usado " + _move.Name + "!", 0.5)
	#await GUI.get_tree().create_timer(0.5).timeout
#Missatge que es mostra quan es modifiquen stats
func showStatsMessage(_target : BattlePokemon, _stat : CONST.STATS, _value : int):
	var text = ""
	var name = ""
	var statText = ""
	if _value == -2:
		text = "bajó mucho"
	elif _value == -1:
		text = "bajó"
	elif _value == 1:
		text = "subió"
	elif _value == 2:
		text = "subió mucho"
	
	#if _target.side.type == CONST.BATTLE_SIDES.PLAYER:
		#name = "de " + _target.Name
	#elif GUI.battle.controller.rules.type == CONST.BATTLER_TYPES.TRAINER:
		#name = "del " + _target.Name + " enemigo"
	#elif GUI.battle.controller.rules.type == CONST.BATTLER_TYPES.WILD_POKEMON:
		#name = "del " + _target.Name + " salvaje"
	#
	if _stat == CONST.STATS.ATA:
		statText = "El ataque "
		#await GUI.battle.showMessage("¡El ataque " + name + " " + text + "!", false, 2.0)
	elif _stat == CONST.STATS.DEF:
		statText = "La defensa "
		#await GUI.battle.showMessage("¡La defensa " + name + " " + text + "!", false, 2.0)
	elif _stat == CONST.STATS.ATAESP:
		statText = "El ataque especial "
		#await GUI.battle.showMessage("¡El ataque especial " + name + " " + text + "!", false, 2.0)	
	elif _stat == CONST.STATS.DEFESP:
		statText = "La defensa especial "
		#await GUI.battle.showMessage("¡La defensa especial " + name + " " + text + "!", false, 2.0)	
	elif _stat == CONST.STATS.VEL:
		statText = "La velocidad "
		#await GUI.battle.showMessage("¡La velocidad " + name + " " + text + "!", false, 2.0)	
	elif _stat == CONST.STATS.ACC:
		statText = "La precisión "
		#await GUI.battle.showMessage("¡La precisión " + name + " " + text + "!", false, 2.0)	
	elif _stat == CONST.STATS.EVA:
		statText = "La evasión "
		#await GUI.battle.showMessage("¡La evasión " + name + " " + text + "!", false, 2.0)		
		
	await GUI.battle.showMessageWait("¡" + statText + _target.battleMessageMiddleDelName + " " + text + "!", 2.0)		

#Missatge que es mostra quan es modifiquen stats
func showStatsFailedMessage(_target : BattlePokemon, _stat : CONST.STATS, _value : int):
	var text = ""
	var name = ""
	var statText = ""

	if _value > 0:
		text = " no puede subir más"
	else:
		text = " no puede bajar más"
	
	
	if _stat == CONST.STATS.ATA:
		statText = "El ataque "
	elif _stat == CONST.STATS.DEF:
		statText = "La defensa "
	elif _stat == CONST.STATS.ATAESP:
		statText = "El ataque especial "
	elif _stat == CONST.STATS.DEFESP:
		statText = "La defensa especial "
	elif _stat == CONST.STATS.VEL:
		statText = "La velocidad "
	elif _stat == CONST.STATS.ACC:
		statText = "La precisión "
	elif _stat == CONST.STATS.EVA:
		statText = "La evasión "

	await GUI.battle.showMessageWait("¡" + statText + _target.battleMessageMiddleDelName + " " + text + "!", 2.0)		

func showLearnMoveMessage(_target : BattlePokemon, _move: MoveInstance) -> bool:
	await GUI.battle.showMessageInput(_target.Name + " intenta aprender " + _move.Name+".")
	await GUI.battle.showMessageInput("Pero " + _target.Name + " no puede aprender más de cuatro movimientos.")
	var msgOption:int = await GUI.battle.showMessageYesNo("¿Quieres sustituir uno de esos movimientos por " + _move.Name + "?")
	while msgOption != null:
		if msgOption == MessageBox.NO:
			var msgOption2:int = await GUI.battle.showMessageYesNo("¿Deja de aprender " + _move.Name + "?")
			if msgOption2 == MessageBox.YES:
				await GUI.battle.showMessageInput("¡"+_target.Name + " no aprendió " + _move.Name + "!")
				return false
			else:
				await GUI.battle.showMessageInput(_target.Name + " intenta aprender " + _move.Name)
				await GUI.battle.showMessageInput("Pero " + _target.Name + " no puede aprender más de cuatro movimientos.")
				msgOption = await GUI.battle.showMessageYesNo("¿Quieres sustituir uno de esos movimientos por " + _move.Name + "?")
		elif msgOption == MessageBox.YES:
			return true
	return false

func showReplacedMoveMessage(_target : BattlePokemon, oldMove: MoveInstance, newMove: MoveInstance):
	await GUI.battle.showMessageInput("1, 2, 3 y ... ... ... ¡puf!")
	await GUI.battle.showMessageInput(_target.Name + " olvidó " + oldMove.Name+".")
	await GUI.battle.showMessageInput("Y...")
	await GUI.battle.showMessageInput("¡" + _target.Name + " aprendió " + newMove.Name+"!")
#Misatges que surten en el moment q es fa un atac i el pk rival queda paralitzat, dormit etc.
#func showAilmentMessage_Move(_target : BattlePokemon, _ailment : CONST.AILMENTS):
	#var name = ""
	#if _target.side.type == CONST.BATTLE_SIDES.PLAYER:
		#name = _target.Name
	#elif GUI.battle.controller.rules.type == CONST.BATTLER_TYPES.TRAINER:
		#name = _target.Name + " enemigo"
	#elif GUI.battle.controller.rules.type == CONST.BATTLER_TYPES.WILD_POKEMON:
		#name = _target.Name + " salvaje"
	#
	#if _ailment == CONST.AILMENTS.PARALYSIS:
		#await GUI.battle.showMessage("¡" + name + " está paralizado! ¡Quizás no pueda moverse!", false, 2.0)
	#elif _ailment == CONST.AILMENTS.SLEEP:
		#await GUI.battle.showMessage("¡" + name + " se durmió!", false, 2.0)
	#elif _ailment == CONST.AILMENTS.FREEZE:
		#await GUI.battle.showMessage("¡" + name + " se ha congelado!", false, 2.0)
	#elif _ailment == CONST.AILMENTS.BURN:
		#await GUI.battle.showMessage("¡" + name + " ha sido quemado!", false, 2.0)
#	elif _ailment == CONST.AILMENTS.POISON:
#		GUI.battle.showMessage("¡La velocidad de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.CONFUSION:
#		GUI.battle.showMessage("¡La precisión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.INFATUATION:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.TRAP:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.NIGHTMARE:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.TORMENT:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.DISABLE:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.YAWN:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.HEAL_BLOCK:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.NO_TYPE_IMMUNITY:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
	#elif _ailment == CONST.AILMENTS.LEECH_SEED:
		#await GUI.battle.showMessage("¡" + name + " fue infectado!", false, 2.0)
#	elif _ailment == CONST.AILMENTS.EMBARGO:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.PERISH_SONG:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.INGRAIN:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#Misatges que surten quan un pkmn intenta fe run moviment i no pot per culpa de l'ailment
#(el foc o el verí resten vida, o o el paralizar o dormir no deixen atacar etc)
#func showAilmentMessage_Effect(_target : BattlePokemon, _ailment : BattleMoveAilmentEffect):
	#var name = ""
#
	#
	#await _ailment.showAilmentEffectMessage()
	
	#if _ailment.ailmentType == CONST.AILMENTS.PARALYSIS:
		#await GUI.battle.showMessage("¡" + name + " está paralizado! ¡No se puede mover!", false, 2.0)
	#elif _ailment.ailmentType == CONST.AILMENTS.SLEEP:
		#await GUI.battle.showMessage("¡" + name + " está dormido como un trono.", false, 2.0)
	#elif _ailment.ailmentType == CONST.AILMENTS.FREEZE:
		#await GUI.battle.showMessage("¡" + name + " está congelado!", false, 2.0)
	#elif _ailment.ailmentType == CONST.AILMENTS.BURN:
		#await GUI.battle.showMessage("¡" + name + " se resiente de la quemadura!", false, 2.0)
#	elif _ailment == CONST.AILMENTS.POISON:
#		GUI.battle.showMessage("¡La velocidad de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.CONFUSION:
#		GUI.battle.showMessage("¡La precisión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.INFATUATION:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.TRAP:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.NIGHTMARE:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.TORMENT:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.DISABLE:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.YAWN:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.HEAL_BLOCK:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.NO_TYPE_IMMUNITY:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
	#elif _ailment == CONST.AILMENTS.LEECH_SEED:
		#await GUI.battle.showMessage("¡Las drenadoras restaron salud a " + name + "!", false, 2.0)
#	elif _ailment == CONST.AILMENTS.EMBARGO:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.PERISH_SONG:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	
#	elif _ailment == CONST.AILMENTS.INGRAIN:
#		GUI.battle.showMessage("¡La evasión de " + _target.Name + " " + text + "!", false, 2.0)	


func show_msgBattle(text:String, showIcon : bool = true, _waitTime : float = 0.0, waitInput = false, waitChoice = false):
	msgBox.show_msgBattle(text, showIcon, _waitTime, waitInput, waitChoice)
	await finished
#Missatge que es mostra quan es debilita un pokemon
func showDefeatedPKMNMessage(_defeatedPKMN : BattlePokemon):
	var type = ""
	if _defeatedPKMN.controllable:
		await GUI.battle.showMessageInput("¡" + _defeatedPKMN.Name + " se debilitó!")
	else:
		if GUI.battle.controller.rules.type == CONST.BATTLER_TYPES.TRAINER:
			type = " enemigo"
		else:
			type = " salvaje"
		await GUI.battle.showMessageInput("¡El " + _defeatedPKMN.Name + type + " se debilitó!")
	
#Missatge que es mostra quan es guanya experiencia al derrotar un pokemon
func showGainedEXPMessage(_pokemonTarget : BattlePokemon, expGained : int):
	print("¡" + _pokemonTarget.Name + " ha ganado " + str(expGained) + " Puntos de Experiencia!")
	await GUI.battle.showMessageInput("¡" + _pokemonTarget.Name + " ha ganado " + str(expGained) + " Puntos de Experiencia!")

func showLevelUpMessage(_pokemonTarget : BattlePokemon, level : int):
	print("¡" + _pokemonTarget.Name + " subió al nivel " + str(level) + "!")
	await GUI.battle.showMessageInput("¡" + _pokemonTarget.Name + " subió al nivel " + str(level) + "!")

func showLevelUpStats(pokemon:BattlePokemon):
	var levelUpPanel:Panel = GUI.levelUp
	await levelUpPanel.showStatsIncrement(pokemon.instance)
	await levelUpPanel.showLevelStats(pokemon.instance)

func showExitMessage(success:bool):
	var msg:String = ""
	if success:
		msg = "¡Escapaste sin problemas!"
	else:
		msg = "¡No puedes huir!"
	print(msg)
	await GUI.battle.showMessageWait(msg,  1.5)
	#await GUI.battle.showMessageInput(msg, false)
	#
#func accept_msg():
	#print("accept")
	##msgBox.accept.emit()
	#GUI.accept.emit()
	##GUI.levelUp.accept.emit()

func hide():
	msgBox.clear_msg()
	#
#func msg_TextDisplayed():
	#print("displayed")
	#textDisplayed.emit()
	#
#func msg_Finished():
	#print("lelelele")
	#print("finished")
	#finished.emit()

func clear():
	msgBox.label.text = ""
	msgBox.label2.text = ""
	msgBox.queue_free()
