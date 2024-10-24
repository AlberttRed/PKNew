class_name BattleEffectController

var battleController : BattleController

var activePKMNAccumulatedEffects : Array[BattleEffect]:
	get:
		return battleController.activeBattleEffects + battleController.active_pokemon.side.activeBattleEffects + battleController.active_pokemon.activeBattleEffects

var activeBattleAccumulatedEffects : Array[BattleEffect]:
	get:
		var effects : Array[BattleEffect] = []
		effects.append_array(battleController.activeBattleEffects)
		for side:BattleSide in battleController.sides:
			effects.append_array(side.activeBattleEffects)
		for pk:BattlePokemon in battleController.activePokemons:
			effects.append_array(pk.activeBattleEffects)
		return effects

func _init(_battleController : BattleController) -> void:
	self.battleController = _battleController
	SignalManager.Battle.Effects.add.connect(addBattleEffect)
	SignalManager.Battle.Effects.remove.connect(removeBattleEffect)
	SignalManager.Battle.Effects.applyAt.connect(applyBattleEffect)

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
	if !target.hasWorkingEffect(_battleEffect):
		target.activeBattleEffects.push_back(_battleEffect)
	print(target.activeBattleEffects)
	update()
	
func removeBattleEffect(_battleEffect : BattleEffect, target):
	if _battleEffect == null:
		return
	match _battleEffect.Type:
		BattleEffect.Type.MOVE:
			removeMoveEffect(_battleEffect, target)
		BattleEffect.Type.STATUS:
			removeStatusEffect(_battleEffect, target)
		BattleEffect.Type.AILMENT:
			removeStatusEffect(_battleEffect, target)
		BattleEffect.Type.ABILITY:
			removeStatusEffect(_battleEffect, target)
		BattleEffect.Type.WEATHER:
			removeStatusEffect(_battleEffect, target)
	update()
	
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
	for battleEffect:BattleEffect in activePKMNAccumulatedEffects:
		if _battleEffectToRemove.name == battleEffect.name :
			target.activeBattleEffects.erase(battleEffect)
			return
	
func removeAbilityEffect(_battleEffect : BattleEffect, target):
	pass

func removeStatusEffect(_battleEffect : BattleEffect, target):
	pass
	
func removeMoveEffect(_battleEffect : BattleEffect, target):
	pass

func update():
	for pk:BattlePokemon in battleController.activePokemons:
		pk.activeAccumulatedEffects = battleController.activeBattleEffects + pk.side.activeBattleEffects + pk.activeBattleEffects



#region APPLY EFFECTS

func applyBattleEffect(functionName:String):
	await Engine.get_main_loop().process_frame
	var applyEffect:Callable = Callable(self, "applyBattleEffectAt"+functionName)
	if !applyEffect.is_null():
		await applyEffect.call()
	SignalManager.Battle.Effects.finished.emit()	
		

func applyBattleEffectAtInitBattleTurn():
	for effect:BattleEffect in activeBattleAccumulatedEffects:
		await effect.applyBattleEffectAtInitBattleTurn()
	
func applyBattleEffectAtEndBattleTurn():
	for effect:BattleEffect in activeBattleAccumulatedEffects:
		await effect.applyBattleEffectAtEndBattleTurn()
		
func applyBattleEffectAtInitPKMNTurn():
	for effect:BattleEffect in activePKMNAccumulatedEffects:
		await effect.applyBattleEffectAtInitPKMNTurn()
	
func applyBattleEffectAtEndPKMNTurn():
	for effect:BattleEffect in activePKMNAccumulatedEffects:
		await effect.applyBattleEffectAtEndPKMNTurn()
		
func applyBattleEffectAtCalculateDamage():
	for effect:BattleEffect in activeBattleAccumulatedEffects:
		await effect.applyBattleEffectAtCalculateDamage()

#endregion
