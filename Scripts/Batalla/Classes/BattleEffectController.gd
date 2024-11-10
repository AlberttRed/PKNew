class_name BattleEffectController

var battleController : BattleController
var activePokmeon : BattlePokemon:
	set(pk):
		if pk!=null:
			print("ef controller active set " + pk.Name)
		activePokmeon = pk

#var activePKMNAccumulatedEffects : Array[BattleEffect]:
	#get:
		#if battleController.active_pokemon != null:
			#return  battleController.activeBattleEffects + battleController.active_pokemon.side.activeBattleEffects + battleController.active_pokemon.activeBattleEffects
		#return []
var activeBattleAccumulatedEffects : Array[BattleEffect]:
	get:
		#return battleController.playerSide.field.activeBattleEffects
		var effects : Array[BattleEffect] = []
		effects.append_array(battleController.field.activeBattleEffects)
		for side:BattleSide in battleController.sides:
			effects.append_array(side.field.activeBattleEffects)
		for pk:BattlePokemon in battleController.activePokemons:
			effects.append_array(pk.activeBattleEffects)
		return effects

func _init(_battleController : BattleController) -> void:
	self.battleController = _battleController
	SignalManager.Battle.Effects.add.connect(addBattleEffect)
	SignalManager.Battle.Effects.remove.connect(removeBattleEffect)
	#SignalManager.Battle.Effects.clear.connect(clearPokemonEffects)

func addBattleEffect(_battleEffect : BattleEffect, target):
	if _battleEffect == null:
		return
	match _battleEffect.Type:
		BattleEffect.Type.MOVE:
			addMoveEffect(_battleEffect, target)
		BattleEffect.Type.STATUS:
			addStatusEffect(_battleEffect, target)
		BattleEffect.Type.AILMENT:
			addStatusEffect(_battleEffect, target)
		BattleEffect.Type.ABILITY:
			addStatusEffect(_battleEffect, target)
		BattleEffect.Type.WEATHER:
			addStatusEffect(_battleEffect, target)
			
	print(target.activeBattleEffects)
	if !target.hasWorkingEffect(_battleEffect.name):
		target.activeBattleEffects.push_back(_battleEffect)
	print(target.activeBattleEffects)
	#update()
	
func removeBattleEffect(_battleEffect : BattleEffect, target):
	if _battleEffect == null:
		return
	match _battleEffect.type:
		BattleEffect.Type.MOVE:
			removeMoveEffect(_battleEffect, target)
		BattleEffect.Type.STATUS:
			removeStatusEffect(_battleEffect, target)
		BattleEffect.Type.AILMENT:
			removeAilmentEffect(_battleEffect, target)
		BattleEffect.Type.ABILITY:
			removeAbilityEffect(_battleEffect, target)
		BattleEffect.Type.WEATHER:
			removeWeatcherEffect(_battleEffect, target)
	#update()
	
func addWeatcherEffect(_battleEffect : BattleEffect, target):
	pass
	
func addAilmentEffect(_battleEffect : BattleEffect, target):
	pass
	
func addAbilityEffect(_battleEffect : BattleEffect, target):
	pass

func addStatusEffect(_battleEffect : BattleEffect, target):
	pass
	
func addMoveEffect(_battleEffect : BattleEffect, target):
	pass
	
func removeWeatcherEffect(_battleEffect : BattleEffect, target):
	pass
	
func removeAilmentEffect(_battleEffectToRemove : BattleEffect, target):
	for battleEffect:BattleEffect in target.activeBattleEffects:
		if _battleEffectToRemove.name == battleEffect.name :
			target.activeBattleEffects.erase(battleEffect)
			return
	
func removeAbilityEffect(_battleEffect : BattleEffect, target):
	pass

func removeStatusEffect(_battleEffectToRemove : BattleEffect, target):
	for battleEffect:BattleEffect in target.activeBattleEffects:
		if _battleEffectToRemove.name == battleEffect.name :
			target.activeBattleEffects.erase(battleEffect)
			return
	
func removeMoveEffect(_battleEffectToRemove : BattleEffect, target):
	for battleEffect:BattleEffect in target.activeBattleEffects:
		if _battleEffectToRemove.name == battleEffect.name :
			target.activeBattleEffects.erase(battleEffect)
			return

#func update():
	#for pk:BattlePokemon in battleController.activePokemons:
		#pk.activeAccumulatedEffects = battleController.activeBattleEffects + pk.side.activeBattleEffects + pk.activeBattleEffects
#


#region APPLY EFFECTS

func applyBattleEffect(functionName:String, pokemon:BattlePokemon=null):
	#await Engine.get_main_loop().process_frame
	var originalPokemon = activePokmeon
	activeBattleAccumulatedEffects.sort_custom(sortByPriority)
	if pokemon != null:
		activePokmeon = pokemon
		activePokmeon.activeAccumulatedEffects.sort_custom(sortByPriority)
	var applyEffect:Callable = Callable(self, "applyBattleEffectAt"+functionName)
	if !applyEffect.is_null():
		await applyEffect.call()
	if pokemon != null:
		activePokmeon = originalPokemon
	#SignalManager.Battle.Effects.finished.emit()	
		

func applyBattleEffectAtInitBattleTurn():
	for effect:BattleEffect in activeBattleAccumulatedEffects:
		await effect.applyBattleEffectAtInitBattleTurn()

func applyBattleEffectAtEndBattleTurn():
	for effect:BattleEffect in activeBattleAccumulatedEffects:
		await effect.applyBattleEffectAtEndBattleTurn()
		
func applyBattleEffectAtInitPKMNTurn():
	if activePokmeon == null:
		return
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:# activePKMNAccumulatedEffects:
		await effect.applyBattleEffectAtInitPKMNTurn()
	
func applyBattleEffectAtEndPKMNTurn():
	if activePokmeon == null:
		return
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:#
		await effect.applyBattleEffectAtEndPKMNTurn()
		
func applyBattleEffectAtCalculateDamage():
	if activePokmeon == null:
		return
	print("apply calculate for " + activePokmeon.Name)
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:#
		await effect.applyBattleEffectAtCalculateDamage()

func applyBattleEffectAtEscapeBattle():
	if activePokmeon == null:
		return
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:#
		await effect.applyBattleEffectAtEscapeBattle()

func applyBattleEffectAtTakeDamage():
	if activePokmeon == null:
		return
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:#
		await effect.applyBattleEffectAtTakeDamage()
	
func applyBattleEffectAtBeforeMove():
	if activePokmeon == null:
		return
	print("apply calculate for " + activePokmeon.Name)
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:#
		await effect.applyBattleEffectAtBeforeMove()
	
func applyBattleEffectAtAfterMove():
	if activePokmeon == null:
		return
	print("apply calculate for " + activePokmeon.Name)
	for effect:BattleEffect in activePokmeon.activeAccumulatedEffects:#
		await effect.applyBattleEffectAtAfterMove()
	
#endregion

func clearPokemonEffects(pokemon:BattlePokemon):
	print(pokemon.Name + " Effects("+ str(pokemon.activeBattleEffects.size()) + "): ")
	pokemon.activeAccumulatedEffects.clear()
	var effectsToDelete:Array[BattleEffect] = []
	for effect: BattleEffect in pokemon.activeBattleEffects:
		print(effect.name)
		effect.clear()
		if !effect.persistent:
			effectsToDelete.push_back(effect)
	for effect: BattleEffect in effectsToDelete:
		pokemon.activeBattleEffects.erase(effect)
	print(pokemon.Name + " Effects("+ str(pokemon.activeBattleEffects.size()) + "): ")
	for effect in pokemon.activeBattleEffects:
		print(effect.name)
	#SignalManager.Battle.Effects.finished.emit()	

func clear():
	SignalManager.Battle.Effects.add.disconnect(addBattleEffect)
	SignalManager.Battle.Effects.remove.disconnect(removeBattleEffect)
	#SignalManager.Battle.Effects.clear.disconnect(clearPokemonEffects)
	activeBattleAccumulatedEffects.clear()
	battleController = null
	activePokmeon = null
	
#Funció que ordena els BattleEffects actius segons prioritat, per saber en quin ordre s'executarà cada un
func sortByPriority(a : BattleEffect, b : BattleEffect):
	return a.priority < b.priority
