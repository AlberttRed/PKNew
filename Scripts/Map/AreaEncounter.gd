extends Resource

class_name AreaEncounter

@export var type : CONST.ENCOUNTER_METHODS
@export_range(0, 100, 1) var EncounterChance : int = 20
#@export_enum(ALL_DAY, MORNING, DAY, NIGHT) var TimeOfDay = 0
@export_enum("ALL_DAY", "MORNING", "DAY", "NIGHT") var TimeOfDay = 0
