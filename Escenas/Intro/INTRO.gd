extends Control

export(StyleBox) var style_selected
export(StyleBox) var style_empty
export(AudioStream) var start_screen_music

var pressed = false
var press_start = false
var inicial_finished = false setget set_inicial_finished,get_inicial_finished
var index = 0
var entries = [] #[get_node("VBoxContainer/Pokedex"),get_node("VBoxContainer/Pokemon"),get_node("VBoxContainer/Mochila"),get_node("VBoxContainer/Jugador"),get_node("VBoxContainer/Guardar"),get_node("VBoxContainer/Opciones"),get_node("VBoxContainer/Salir")]
var signals = [] #["pokedex","pokemon","item","player","save","option","exit"]
var mod = modulate

func _ready():
	add_user_signal("continue")
	add_user_signal("new_game")
	set_process(false)
	if GAME_DATA.save_exists():
		entries = [$Menu/VBoxContainer/CONTINUE,$"Menu/VBoxContainer/NEW GAME"]
		signals = ["continue","new_game"]
		$Menu/VBoxContainer/CONTINUE.visible = true
	else:
		entries = [$"Menu/VBoxContainer/NEW GAME"]
		signals = ["new_game"]
		$Menu/VBoxContainer/CONTINUE.visible = false

func start():
	show()
	$Inicial.visible = true
	$AnimationPlayer.play("fade_out")
	yield($AnimationPlayer, "animation_finished")
	$AudioStreamPlayer2D.play_music(start_screen_music)
	$AnimationPlayer.play("start_screen")
	yield($AnimationPlayer, "animation_finished")
	
	$AnimationPlayer2.play("press_enter")
	press_start = true
	#update_styles()

func _input(event):
	if event.is_action_pressed("ui_start") and !pressed:
		if	$Inicial.visible and press_start:
			pressed = true
			$AnimationPlayer.stop()
			$AnimationPlayer.play("FadeOut (copy)")
			$AudioStreamPlayer2D.stop_music(2.0)
			yield($AnimationPlayer, "animation_finished")
			$Inicial/press_start.visible = false
			modulate = mod
			$Menu.visible = true
			$Inicial.visible = false
			set_process(true)
			update_styles()
		elif $Inicial.visible and $AnimationPlayer.is_playing() and inicial_finished:
			$AnimationPlayer.stop()
			$AnimationPlayer.play("complete_start_screen")
			press_start = true
		

func _process(delta):
	if $Menu.visible:
		if (INPUT.ui_down.is_action_just_pressed()): #Input.is_action_pressed("ui_down"):#
			var i = index
			while (i < entries.size()-1):
				i+=1
				if (entries[i].is_visible()):
					index=i
					break
			update_styles()
		if (INPUT.ui_up.is_action_just_pressed()):#Input.is_action_pressed("ui_up"):#(INPUT.up.is_action_just_pressed()):
			var i = index
			while (i > 0):
				i-=1
				if (entries[i].is_visible()):
					index=i
					break
			update_styles()
		
		if (INPUT.ui_accept.is_action_just_pressed()):#Input.is_action_pressed("ui_accept"):#(INPUT.ui_accept.is_action_just_pressed()):
			emit_signal(signals[index])
			$Menu.visible = false
			hide()

func update_styles():
	for p in range(entries.size()):
		if (p==index):
			entries[p].add_stylebox_override("panel", style_selected)
		else:
			entries[p].add_stylebox_override("panel",style_empty)
			
func get_inicial_finished():
	return inicial_finished
	
func set_inicial_finished(finished):
	inicial_finished = finished
