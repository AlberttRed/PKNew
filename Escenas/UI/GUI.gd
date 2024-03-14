
extends CanvasLayer

signal input
signal selected_choice
signal accept

var next = false

@onready var msg = MessageBox.new($MSG)
#onready var options = get_node("OPTIONS")
@onready var menu = $MAIN_MENU
@onready var battle = $BATTLE
@onready var chs = $CHOICES
@onready var party = $PARTY
#onready var bag = get_node("BAG")
@onready var transition = $TRANSITION
@onready var levelUp = $LEVELUP

var choices_options = null

func _ready():
#	$INTRO.connect("continue", GAME_DATA, "load_game")
#	$INTRO.connect("new_game", GAME_DATA, "new_game")
#	add_user_signal("finished")
#	add_user_signal("input")
	menu.connect("pokemon", Callable(self, "show_party"))
#	menu.connect("save", self, "save")
#	menu.connect("bag", self, "show_bag")
	pass
#	options.connect("text_speed_changed", self, "_on_text_speed_changed")
	#msg.connect("input", self, "send_input")
#
#func _init():
#	get_node("MSG").Panel = CONST.Window_StyleBoxç

	
func show_msg(text="", wait = null, obj = null, sig="", _choices_options = [], _close = true):
	msg.connect("finished", Callable(self, "close_msg"))
	choices_options = _choices_options
	var choices = []
	var close = _close
	if choices_options != [] and choices_options != null:
			choices = _choices_options[0]
			if choices != null and choices != []:
				close = false
				msg.disconnect("finished", Callable(self, "close_msg"))
				msg.connect("finished", Callable(self, "show_choices"))
				
	msg.show_msg(text,wait,obj,sig, close)#choices_options.size() == 0 or ((choices_options[0] == null or choices_options[0].size() == 0) and close == true))

func show_choices():
	for c in choices_options[0]:
		#print("add choice")
		if !chs.has_user_signal(c):
			chs.add_user_signal(c)
		chs.connect(c, Callable(self, "add_choice_cmd"))
		chs.add_choice(c)

	chs.show_choices(choices_options[1], choices_options[2])
	await chs.exit
	chs.clear_choices()
	msg.clear_msg()
	
	for c in choices_options[0]:
		chs.disconnect(c, Callable(self, "add_choice_cmd"))

	close_msg()
	
	
	
func add_choice_cmd(c):
	selected_choice.emit(c)
	
func close_msg():
	GLOBAL.disconnect_signal(msg, "finished", Callable(self, "show_choices"))
	GLOBAL.disconnect_signal(msg, "finished", Callable(self, "close_msg"))
	input.emit()
	

#func show_options():
#	options.show()
#	options.set_process(true)
#	yield(options,"exit")
#	options.set_process(false)
#
func clear_msg():
	msg.clear_msg()

func clear_choices():
	msg.clear_msg()

func show_menu():
	menu.start = false
	menu.show()
	#menu.set_process(true)
	await menu.exit
	#yield(menu,"exit")
	menu.set_process(false)

func isVisible():
	return msg.is_visible() || chs.is_visible() || menu.is_visible() || party.is_visible() || battle.is_visible() || transition.is_visible()# || $INTRO.is_visible() || bag.is_visible() || transition.is_visible()#|| options.is_visible()

#func _on_text_speed_changed(speed):
#	get_node("MSG/Timer 2").set_wait_time(CONST.TEXT_SPEEDS[speed])

#func _on_menu_options():
#	menu.hide()
#	menu.set_process(false)
#	show_options()
#	yield(options, "exit")
#	menu.show()
#	menu.set_process(true)
#
#func send_input():
#	emit_signal("input")
#
#func show_bag():
#	menu.hide()
#	menu.set_process(false)
#	bag.show_bag()
#	bag.set_process(true)
#	yield(bag,"salir")
#	bag.hide()
#	bag.set_process(false)
#	menu.show()
#	menu.set_process(true)
#
#
func show_party():
	print("miau")
	menu.hide()
	menu.set_process(false)
	party.show_party()
	party.set_process(true)
	await party.exit
	#yield(party,"salir")
	party.hide_party()
	party.set_process(false)
	menu.show()
	menu.set_process(true)
	
func _input(event):
	#if ($MSG.visible and !chs.visible and msg.text_completed):
	if (visible):
		if event.is_action_pressed("ui_accept"):
			Input.action_release("ui_accept")
			INPUT.ui_accept.free_state()
			print("GUI accept")
			accept.emit()
#
#func start_battle(double, trainer1, trainer2, trainer3 = null, trainer4 = null):#wild_encounter(id, level):
#	battle.show()
#	battle.start_battle(double, trainer1, trainer2, trainer3, trainer4)
#	#battle.wild_encounter(id, level)
#
#func init_battle(double, trainer1, trainer2, trainer3 = null, trainer4 = null):
#	battle.start_battle(double, trainer1, trainer2, trainer3, trainer4)
#
#func set_next():
#	next = true
#
#func save():
#	print("SAVING")
#	GAME_DATA.save_game()
#
#func start_intro():
#	$INTRO.start()
#
func play_transition(animation : String):
	transition.play(animation)
	await transition.finished 
