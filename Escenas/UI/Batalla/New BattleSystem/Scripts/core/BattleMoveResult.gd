class_name BattleMoveResult
extends RefCounted

var targets: Array[BattleSpot_Refactor] = []
var damage_results: Dictionary = {} # key: BattlePokemon_Refactor, value: Array[DamageResult]
var missed: bool = false
var num_hits: int = 1
