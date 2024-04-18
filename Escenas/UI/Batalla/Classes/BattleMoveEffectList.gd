class_name BattleMoveEffects

func getMoveEffect(move : BattleMove) -> BattleMoveEffect:

	var t_num : String = "%03d" % (move.category + 1)
	return get("MoveEffect_" + t_num).new(move, move.pokemon)

# Effect d'atacs simples, que només fan mal CATEGORY DAMAGE
class MoveEffect_001 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("CATEGORY DAMAGE")

		await doAnimation(to)
		for t in to:
			if moveInflictsDamage():
				print("Do damage!")
				#Farà animació de colpejar, amb el so
				var damage : int =  move.calculateDamage(t.activePokemon)
				await move.doDamage(t.activePokemon, damage)

	func doAnimation(to):
		await move.doAnimation(to[0])
		

# Effect d'atacs que només proquen ailment / canvi d estat : CATEGORY AILMENT
class MoveEffect_002 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("CATEGORY AILMENT")

		doAnimation(to)
		for t in to:

			if moveCausesAilment(): 
				print("Cause ailment!")
				#Farà animació de cremar, dormir, el que sigui
				await move.causeAilment(t.activePokemon)

	func doAnimation(to):
		print("jaja lol")

# Effect d'atacs que només modifiquen stats  CATEGORY CHANGE_STATS
class MoveEffect_003 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("CATEGORY CHANGE_STATS")

		doAnimation(to)
		for t in to:

			if moveModifyStats():
				print("Modify stat!")
				#Farà animació de baixar o pujar stats, amb el so
				await move.modifyStats(t.activePokemon)

	func doAnimation(to):
		print("jaja lol")

#Moviments que únicament curen CATEGORY HEAL
class MoveEffect_004 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY HEAL")


	func doAnimation(to):
		print("jaja lol")
		

# Effect d'atacs que fan mal i modifiquen provoquen ailment /canvi d estat CATEGORY DAMAGE_AILMENT
class MoveEffect_005 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("CATEGORY DAMAGE_AILMENT")

		doAnimation(to)
		for t in to:
			if moveInflictsDamage():
				print("Do damage!")
				#Farà animació de colpejar, amb el so
				var damage : int =  move.calculateDamage(t.activePokemon)
				await move.doDamage(t.activePokemon, damage)


			if moveCausesAilment(): 
				print("Cause ailment!")
				#Farà animació de cremar, dormir, el que sigui
				await move.causeAilment(t.activePokemon)

	func doAnimation(to):
		print("jaja lol")

# Effect d'atacs que ... CATEGORY SWAGGER
class MoveEffect_006 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY SWAGGER")


	func doAnimation(to):
		print("jaja lol")


# Effect d'atacs que fan mal i baixen stats CATEGORY DAMAGE_LOWER
class MoveEffect_007 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("CATEGORY DAMAGE_LOWER")

		doAnimation(to)
		for t in to:
			if moveInflictsDamage():
				print("Do damage!")
				#Farà animació de colpejar, amb el so
				var damage : int =  move.calculateDamage(t.activePokemon)
				await move.doDamage(t.activePokemon, damage)


			if moveModifyStats():
				print("Modify stat!")
				#Farà animació de baixar o pujar stats, amb el so
				await move.modifyStats(t.activePokemon)

	func doAnimation(to):
		print("jaja lol")


# Effect d'atacs que fan mal i pugen stats CATEGORY DAMAGE_RAISE
class MoveEffect_008 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("CATEGORY DAMAGE_RAISE")

		doAnimation(to)
		for t in to:
			if moveInflictsDamage():
				print("Do damage!")
				#Farà animació de colpejar, amb el so
				var damage : int =  move.calculateDamage(t.activePokemon)
				await move.doDamage(t.activePokemon, damage)


			if moveModifyStats():
				print("Modify stat!")
				#Farà animació de baixar o pujar stats, amb el so
				await move.modifyStats(t.activePokemon)

	func doAnimation(to):
		print("jaja lol")


# Effect d'atacs que fan mal i curen CATEGORY DAMAGE_HEAL
class MoveEffect_009 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY DAMAGE_HEAL")

	func doAnimation(to):
		print("jaja lol")


# Effect d'atacs que fan KO en un sol atac CATEGORY OHKO
class MoveEffect_010 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY OHKO")

	func doAnimation(to):
		print("jaja lol")

# Effect d'atacs que afecten a tot el camp del combat CATEGORY WHOLE_FIELD
class MoveEffect_011 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY WHOLE_FIELD")

	func doAnimation(to):
		print("jaja lol")
		

# Effect d'atacs que afecten tots els pokemons d'un dels dos sides de la batalla CATEGORY FIELD
class MoveEffect_012 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY FIELD")

	func doAnimation(to):
		print("jaja lol")
		
# Effect d'atacs que provoquen un canvi de pokemon del rival CATEGORY FORCE_SWITCH
class MoveEffect_013 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY FORCE_SWITCH")

	func doAnimation(to):
		print("jaja lol")
		
# Effect d'atacs unics. Aqui s'hauran de fer efectes personalitzats per cada un CATEGORY UNIQUE
class MoveEffect_014 extends BattleMoveEffect:
	func doEffect(to: Array[BattleSpot]):
		print("TO DO: CATEGORY UNIQUE")

	func doAnimation(to):
		print("jaja lol")
