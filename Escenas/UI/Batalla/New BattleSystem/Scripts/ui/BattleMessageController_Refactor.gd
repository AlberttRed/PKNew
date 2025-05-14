extends Node
class_name BattleMessageController_Refactor

func get_intro_messages(
	rules: BattleRules,
	player_pokemon: Array[BattlePokemon_Refactor],
	enemy_pokemon: Array[BattlePokemon_Refactor],
	player_trainers: Array[String],
	enemy_trainers: Array[String]) -> Array[Dictionary]:
	var messages: Array[Dictionary] = []

	match rules.mode:
		BattleRules.BattleModes.SINGLE:
			if rules.type == BattleRules.BattleTypes.WILD:
				messages.append({
					"type": "wait",
					"text": "¡Un " + enemy_pokemon[0].get_name() + " salvaje apareció!",
					"wait_time": 1.5
				})
			else:
				var enemy = enemy_trainers[0]
				messages.append({
					"type": "input",
					"text": "¡" + enemy + " quiere luchar!"
				})
				messages.append({
					"type": "wait",
					"text": "¡" + enemy + " envió a " + enemy_pokemon[0].get_name() + "!",
					"wait_time": 1.2
				})
			messages.append({
				"type": "wait",
				"text": "¡Adelante, " + player_pokemon[0].get_name() + "!",
				"wait_time": 0.5
			})

		BattleRules.BattleModes.DOUBLE:
			if rules.type == BattleRules.BattleTypes.WILD:
				messages.append({
					"type": "wait",
					"text": "¡Un " + enemy_pokemon[0].get_name() + " y un " + enemy_pokemon[1].get_name() + " salvajes aparecieron!",
					"wait_time": 1.5
				})
			else:
				if enemy_trainers.size() == 1:
					messages.append({
						"type": "input",
						"text": "¡" + enemy_trainers[0] + " quiere luchar!"
					})
					messages.append({
						"type": "wait",
						"text": "¡" + enemy_trainers[0] + " envió a " + enemy_pokemon[0].get_name() + " y " + enemy_pokemon[1].get_name() + "!",
						"wait_time": 1.4
					})
				elif enemy_trainers.size() == 2:
					messages.append({
						"type": "input",
						"text": "¡" + enemy_trainers[0] + " y " + enemy_trainers[1] + " quieren luchar!"
					})
					messages.append({
						"type": "wait",
						"text": "¡" + enemy_trainers[0] + " y " + enemy_trainers[1] + " enviaron a " + enemy_pokemon[0].get_name() + " y " + enemy_pokemon[1].get_name() + "!",
						"wait_time": 1.4
					})

			if player_trainers.size() == 1:
				messages.append({
					"type": "wait",
					"text": "¡Adelante, " + player_pokemon[0].get_name() + " y " + player_pokemon[1].get_name() + "!",
					"wait_time": 0.5
				})
			elif player_trainers.size() == 2:
				messages.append({
					"type": "wait",
					"text": "¡" + player_trainers[0] + " y " + player_trainers[1] + " enviaron a " + player_pokemon[0].get_name() + " y " + player_pokemon[1].get_name() + "!",
					"wait_time": 0.5
				})

	return messages

func get_damage_result_messages(choice: BattleMoveChoice_Refactor, dmg: DamageResult, target: BattlePokemon_Refactor) -> Array[Dictionary]:
	var messages: Array[Dictionary] = []

	if dmg.is_critical:
		messages.append({ "type": "input", "text": "¡Golpe crítico!" })

	if dmg.is_super_effective():
		messages.append({ "type": "input", "text": "¡Es muy eficaz!" })
	elif dmg.is_not_very_effective():
		messages.append({ "type": "input", "text": "No es muy eficaz..." })
	elif dmg.is_ineffective():
		messages.append({ "type": "input", "text": "No afecta a %s..." % target.nickname })

	return messages
	
func get_failed_move_message(user: BattlePokemon_Refactor) -> Dictionary:
	return {
		"type": "input",
		"text": "¡El ataque de %s falló!" % [user.get_name()]
	}

func get_multi_hit_message(num_hits: int) -> Dictionary:
	return {
		"type": "input",
		"text": "N.º de golpes: %d." % num_hits
	}

func get_faint_message(pokemon: BattlePokemon_Refactor) -> Dictionary:
	return {
		"type": "input",
		"text": "%s se ha debilitado." % pokemon.nickname
	}
