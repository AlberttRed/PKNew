class_name BattleEffect_Refactor
extends RefCounted

enum Phases {
	ON_BEFORE_MOVE,
	ON_AFTER_MOVE,
	ON_END_TURN,
	ON_SWITCH_IN,
	ON_SWITCH_OUT,
	ON_ENTRY_BEGIN
}

enum Modifiers {
	MOVE_POWER,
	MOVE_ACCURACY,
	CRITICAL_CHANCE
}
