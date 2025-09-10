# NatureGenerator.gd
@tool
extends EditorScript

const Nature = preload("res://Database/Classes/Nature.gd")
const Stat = StatTypes.Stat

var output_dir := "res://Resources/Natures/"

var natures_data := [
	# id, display_name, increased_stat, decreased_stat
	["hardy",  "Firme",   Stat.ATTACK,     Stat.ATTACK],
	["lonely", "AudaZ",   Stat.ATTACK,     Stat.DEFENSE],
	["brave",  "Osada",   Stat.ATTACK,     Stat.SPEED],
	["adamant","Fuerte",  Stat.ATTACK,     Stat.SP_ATTACK],
	["naughty","Grosera", Stat.ATTACK,     Stat.SP_DEFENSE],
	
	["bold",   "Cauta",   Stat.DEFENSE,    Stat.ATTACK],
	["docile", "Dócil",   Stat.DEFENSE,    Stat.DEFENSE],
	["relaxed","Plácida", Stat.DEFENSE,    Stat.SPEED],
	["impish", "Amable",  Stat.DEFENSE,    Stat.SP_ATTACK],
	["lax",    "Floja",   Stat.DEFENSE,    Stat.SP_DEFENSE],
	
	["timid",  "Tímida",  Stat.SPEED,      Stat.ATTACK],
	["hasty",  "Activa",  Stat.SPEED,      Stat.DEFENSE],
	["serious","Seria",   Stat.SPEED,      Stat.SPEED],
	["jolly",  "Alegre",  Stat.SPEED,      Stat.SP_ATTACK],
	["naive",  "Ingenua", Stat.SPEED,      Stat.SP_DEFENSE],
	
	["modest", "Modesta", Stat.SP_ATTACK,  Stat.ATTACK],
	["mild",   "Afable",  Stat.SP_ATTACK,  Stat.DEFENSE],
	["quiet",  "Huraña",  Stat.SP_ATTACK,  Stat.SPEED],
	["bashful","Rara",    Stat.SP_ATTACK,  Stat.SP_ATTACK],
	["rash",   "Alocada", Stat.SP_ATTACK,  Stat.SP_DEFENSE],
	
	["calm",   "Mansa",   Stat.SP_DEFENSE, Stat.ATTACK],
	["gentle", "Miedosa", Stat.SP_DEFENSE, Stat.DEFENSE],
	["sassy",  "Pícara",  Stat.SP_DEFENSE, Stat.SPEED],
	["careful","Serena",  Stat.SP_DEFENSE, Stat.SP_ATTACK],
	["quirky", "Extraña", Stat.SP_DEFENSE, Stat.SP_DEFENSE],
]

func _run():
	var dir := DirAccess.open(output_dir)
	if dir == null:
		DirAccess.make_dir_recursive_absolute(output_dir)
	
	for nature_data in natures_data:
		var id = nature_data[0]
		var display_name = nature_data[1].capitalize()
		var inc_stat = nature_data[2]
		var dec_stat = nature_data[3]

		var nature = Nature.new()
		nature.id = id
		nature.display_name = display_name
		nature.increased_stat = inc_stat
		nature.decreased_stat = dec_stat

		var file_path = "%s%s.tres" % [output_dir, id.to_upper()]
		ResourceSaver.save(nature, file_path)

	print("✔️ Naturalezas generadas en: %s" % output_dir)
