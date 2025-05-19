extends Resource
class_name BattleEffect_Refactor

enum Scope { NONE, POKEMON, SIDE, FIELD }

enum BattleEffectPhase {
	BEGIN_TURN,
	BEFORE_MOVE,
	AFTER_MOVE,
	ON_SWITCH_IN,
	END_TURN
}

var name: String = ""
var scope: Scope = Scope.NONE
var source: Node = null
var target: Node = null
var duration: int = -1

func apply_at_begin_turn(_controller): pass
func apply_before_move(_controller): pass
func apply_after_move(_controller): pass
func apply_on_switch_in(_controller): pass
func apply_at_end_turn(_controller): pass
func on_remove(): pass
