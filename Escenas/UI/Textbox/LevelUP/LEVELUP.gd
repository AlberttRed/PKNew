extends Panel


@onready var statsNames:Array[RichTextLabel]
@onready var statsValues:Array[RichTextLabel]

var pokemon: PokemonInstance

func _ready():
	for l in $HBoxContainer/Stats.get_children() : statsNames.push_back(l)
	for l in $HBoxContainer/StatsValues.get_children() : statsValues.push_back(l)
	
func showStatsIncrement(pokemon:PokemonInstance):
	show()
	statsValues[CONST.STATS.HP].setText(" + " + str(pokemon.getHPStat(pokemon.level) - pokemon.getHPStat(pokemon.level-1)))
	statsValues[CONST.STATS.ATA].setText(" + " + str(pokemon.getAttackStat(pokemon.level) - pokemon.getAttackStat(pokemon.level-1)))
	statsValues[CONST.STATS.DEF].setText(" + " + str(pokemon.getDefenseStat(pokemon.level) - pokemon.getDefenseStat(pokemon.level-1)))
	statsValues[CONST.STATS.ATAESP].setText(" + " + str(pokemon.getSpAttackStat(pokemon.level) - pokemon.getSpAttackStat(pokemon.level-1)))
	statsValues[CONST.STATS.DEFESP].setText(" + " + str(pokemon.getSpDefenseStat(pokemon.level) - pokemon.getSpDefenseStat(pokemon.level-1)))
	statsValues[CONST.STATS.VEL].setText(" + " + str(pokemon.getSpeedStat(pokemon.level) - pokemon.getSpeedStat(pokemon.level-1)))
	
	await GUI.accept
	hide()
	
func showLevelStats(pokemon:PokemonInstance):
	show()
	statsValues[CONST.STATS.HP].setText("[right]%s[/right]" % pokemon.getHPStat(pokemon.level))
	statsValues[CONST.STATS.ATA].setText("[right]%s[/right]" % pokemon.getAttackStat(pokemon.level))
	statsValues[CONST.STATS.DEF].setText("[right]%s[/right]" % pokemon.getDefenseStat(pokemon.level))
	statsValues[CONST.STATS.ATAESP].setText("[right]%s[/right]" % pokemon.getAttackStat(pokemon.level))
	statsValues[CONST.STATS.DEFESP].setText("[right]%s[/right]" % pokemon.getSpDefenseStat(pokemon.level))
	statsValues[CONST.STATS.VEL].setText("[right]%s[/right]" % pokemon.getSpeedStat(pokemon.level))

	await GUI.accept
	
	hide()
