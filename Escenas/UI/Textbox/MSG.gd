extends Panel

signal text_displayed
signal finished
signal finished_waiting
signal accept

const MAX_CHARS_PER_LINE = 41

#@export_multiline var msg:String = "¡Hola a todos! ¡Bienvenidos al mundo de POKÉMON! ¡Me llamo OAK! ¡Pero la gente me llama el PROFESOR POKÉMON!"
var msg:
	set(v):
		msg = v
		
@onready var label = $Label
@onready var label2 = $Label/Label2
@onready var next = $next
@onready var animationPlayer = $AnimationPlayer
@onready var char_percent = null
@onready var timer = $Timer


var writing
var c = 0
var skp = 0
var stop = null
var close = true
#var char_percent = 1.0 / label.get_total_character_count()
var text_completed = false

func _init():
	pass

func _ready():
	#show_msg("¡Hola a todos! ¡Bienvenidos al mundo de POKÉMON! ¡Me llamo OAK! ¡Pero la gente me llama el PROFESOR POKÉMON!")
	hide()

func show_msg(text, _stop = null, _obj = null, _sig = null, _close = true):
	stop = _stop
	close = _close
	text_completed = false
	if (text.is_empty()):
		print("sierrate")
		hide()
		return
	show()	
	if stop != null:
		next.hide()
	skp=0
	text = autoclip(text)
	msg = text
	label.text = text
	label2.text = text

	label.scroll_following = true
	label2.scroll_following = true
	label.visible_characters = 0
	label2.visible_characters = 0
	label.scroll_to_line(0)
	label2.scroll_to_line(0)
	#var count = label.get_total_character_count()-1
	char_percent = 1.0 / label.get_total_character_count()
	#print("char_percent ", char_percent)

	timer.start()
	await text_displayed
	
	if stop == null:
		next.show()

		if !animationPlayer.is_playing():
			animationPlayer.play("Idle")

		await accept

		animationPlayer.stop()		
		next.hide()
		if close:
			hide()
			
	if stop != null:
		wait(stop)
		await finished_waiting
		hide()
	finished.emit()

func clear_msg():
	hide()
	
func wait(seconds):
	await get_tree().process_frame
	var t = Timer.new()
	t.set_wait_time(seconds)
	add_child(t)
	t.start()

	t.queue_free()
	emit_signal("finished_waiting")



func _on_timer_timeout():
	if (label.visible_characters < label.text.length()-1):

		label.visible_characters += 1
		label2.visible_characters += 1

		if (msg[label.visible_characters]=='\n'):
			if (skp >= 1):
				text_completed = false
				if stop == null:
					next.show()
					if !animationPlayer.is_playing():
						animationPlayer.play("Idle")
					timer.stop()
					while (!INPUT.ui_accept.is_action_just_pressed()):#(!Input.is_action_pressed("ui_accept")):
						await get_tree().process_frame
					timer.start()
					animationPlayer.stop()	

					next.hide()
				label.scroll_to_line(skp)
				label2.scroll_to_line(skp)
			skp+=1
	

		c += 1
	else:
		label.visible_characters += 1
		label2.visible_characters += 1
		c = 0
		timer.stop()
		text_completed = true
		emit_signal("text_displayed")

func autoclip(text=""):
	writing = true
	var lines = [""]
	for p in text.split("\n", false):
		for w in p.split(" ", false):
			if (lines[lines.size()-1].length()+w.length()+1 <= MAX_CHARS_PER_LINE):
				if lines[lines.size()-1] == "":
					lines[lines.size()-1] = w
				else:
					lines[lines.size()-1] += " "+w;
			else:
				lines.append(w)
	text = ""
	for l in range(lines.size()-1):
		#print(lines[l])
		text += lines[l] + "\n"
	#print(lines[lines.size()-1])
	text += lines[lines.size()-1]
	writing = false
	return text

	
func _input(event):
	if visible and !GUI.chs.visible and text_completed:
		if event.is_action_pressed("ui_accept"):
			Input.action_release("ui_accept")
			INPUT.ui_accept.free_state()
			accept.emit()
