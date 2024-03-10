extends Node2D

signal updated

var total_hp :int = 0
var actual_hp :int = 0

func setHPBar(pokemon : BattlePokemon):
	pokemon.updateHP.connect(Callable(self, "on_health_changes"))
	actual_hp = pokemon.hp_actual
	total_hp = pokemon.hp_total
	$TextureProgressBar.max_value = total_hp
	$TextureProgressBar.value = actual_hp
	$lblHP.text = str(actual_hp) + "/" + str(total_hp)
	pokemon.HPbar = self
	update_color()
#	percentage = float(pokemon_target.hp_actual) / float(pokemon_target.hp_total)
#	$health.scale = Vector2(percentage, 1)
	
	
func update_color():
	var percentage = float($TextureProgressBar.value) / float($TextureProgressBar.max_value)
	if percentage > 0.5:
		$TextureProgressBar.tint_progress = CONST.BATTLE.HPCOLORGREEN
	elif percentage >= 0.20 and percentage <=0.50:
		$TextureProgressBar.tint_progress = CONST.BATTLE.HPCOLORYELLOW
	else:
		$TextureProgressBar.tint_progress = CONST.BATTLE.HPCOLORRED

func on_health_changes(hp):
	animate_value(actual_hp, hp)
	actual_hp = hp

func updateHP(hp):
	await animate_value(actual_hp, hp)
	actual_hp = hp
	updated.emit()
	
func animate_value(start, end):
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($TextureProgressBar, "value", end, 1.0)
	tween.tween_method(Callable(self, "set_count_text"), start, end, 1.0)
	await tween.finished
	
func set_count_text(value):
	$lblHP.text = str(round(value)) + "/" + str(total_hp)
	update_color()

func clear(pokemon):
	total_hp = 0
	actual_hp = 0
	$TextureProgressBar.value = 0
	$TextureProgressBar.max_value = 0
	pokemon.updateHP.disconnect(Callable(self, "on_health_changes"))
