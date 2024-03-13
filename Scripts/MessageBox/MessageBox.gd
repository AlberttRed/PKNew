extends Node

class_name MessageBox


signal textDisplayed
signal finished
signal finishedWaiting
signal accept

const MAX_CHARS_PER_LINE = 41

var msgBox : Panel = null

var msg:
	set(v):
		msg = v

var writing
var c = 0
var skp = 0
var stop = null
var close = true
var text_completed = false

@onready var char_percent = null

var label = null
var label2 = null
var timer : Timer = null
var next : Sprite2D = null
var animationPlayer : AnimationPlayer = null
#@onready var timer: Timer = null
#@onready var animationPlayer: AnimationPlayer = null


func _init(_msgBox : Panel):
	msgBox = _msgBox
	char_percent = 1.0 / msgBox.get_node("Label").get_total_character_count()
	
	label = msgBox.get_node("Label")
	label2 = msgBox.get_node("Label/Label2")
	timer = msgBox.get_node("Timer")
	next = msgBox.get_node("next")
	animationPlayer = msgBox.get_node("AnimationPlayer")
	
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	
#	timer = Timer.new()
#	setTimer(timer)
#	animationPlayer = AnimationPlayer.new()
#	msgBox.add_child(animationPlayer)
#	msgBox.add_child(timer)
	
func show_msg(text, _stop = null, _obj = null, _sig = null, _close = true):
	stop = _stop
	close = _close
	text_completed = false
	if (text.is_empty()):
		print("sierrate")
		msgBox.hide()
		return
	msgBox.show()	
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
	await textDisplayed
	
	if stop == null:
		next.show()

		if !animationPlayer.is_playing():
			animationPlayer.play("Idle")

		await accept

		animationPlayer.stop()		
		next.hide()
		if close:
			msgBox.hide()
			
	if stop != null:
		wait(stop)
		await finishedWaiting
		msgBox.hide()
	finished.emit()

func clear_msg():
	msgBox.hide()
	
func wait(seconds):
	#await get_tree().process_frame
	var t = Timer.new()
	t.set_wait_time(seconds)
	msgBox.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	finishedWaiting.emit()
	#emit_signal("finished_waiting")



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
		textDisplayed.emit()
		#emit_signal("text_displayed")

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
	
func is_visible():
	return msgBox.is_visible()

func show_msgBattleOLD(text, _stop = null, _obj = null, _sig = null, _close = true):
	stop = _stop
	close = _close
	text_completed = false
	if (text.is_empty()):
		print("sierrate")
		msgBox.hide()
		return
	msgBox.show()	
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
	await textDisplayed
	
	if stop == null:
		next.show()

		if !animationPlayer.is_playing():
			animationPlayer.play("Idle")

		await accept

		animationPlayer.stop()		
		next.hide()
		if close:
			msgBox.hide()
			
	if stop != null:
		wait(stop)
		await finishedWaiting
		msgBox.hide()
	finished.emit()


func show_msgBattleold2(text : String, showIcon : bool = true, _waitTime : float = 0.0):
	if _waitTime > 0.0:
		stop = _waitTime
	else:
		stop = null

	text_completed = false
	if (text.is_empty()):
		print("sierrate")
		msgBox.hide()
		return
	msgBox.show()	
	if !showIcon:
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
	await textDisplayed
	
	if stop == null:
		if showIcon:
			next.show()

		if !animationPlayer.is_playing():
			animationPlayer.play("Idle")

		await accept

		animationPlayer.stop()		
		next.hide()
#		if close:
#			msgBox.hide()
			
	if stop != null:
		wait(stop)
		await finishedWaiting
		#msgBox.hide()
	finished.emit()


func show_msgBattle(text : String, showIcon : bool = true, _waitTime : float = 0.0, waitInput:bool = false):
	if _waitTime > 0.0:
		stop = _waitTime
	else:
		stop = null

	text_completed = false
	if (text.is_empty()):
		print("sierrate")
		msgBox.hide()
		return
	msgBox.show()	
	if !showIcon:
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
	await textDisplayed
	
	if stop != null:
		wait(stop)
		await finishedWaiting
		
	if waitInput:
		if showIcon:
			next.show()

		if !animationPlayer.is_playing():
			animationPlayer.play("Idle")

		await accept

		animationPlayer.stop()		
		next.hide()

	finished.emit()
