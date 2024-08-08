extends Node

#signal cmd_started
#signal cmd_finished
#signal waited_signal

@export var Target: NodePath
enum Directions { LEFT, RIGHT, UP, DOWN, TURN_LEFT, TURN_RIGHT, TURN_UP, TURN_DOWN, WAIT025, WAIT050, WAIT1 }
@export var move_commands: Array[Directions]

var t
var index = 0
var actual_command = null
var last_command_exec = null
var type = null

func _init():
	set_physics_process(false)

func _ready():
	set_physics_process(false)
	add_to_group(str(GLOBAL.actual_map.name))
	if !Target.is_empty():
		print("setting t")	
		t = get_node(Target)
	else:
		print("setting t")	
		t = GLOBAL.PLAYER
	#SignalManager.CMD.waited.connect(Callable(self, "waited"))

func exec():
	SignalManager.CMD.started.emit()
	SignalManager.CMD.waited.connect(Callable(self, "waited"))
	print(str(name) + " started")
	
	if move_commands != []:
		print("target ", t)	
		if t.is_in_group("Player"):
			type = ""
		elif t.is_in_group("Event"):
			type = "_event"
		if !t.turned_signal.is_connected(Callable(self, "turned")):
			t.turned_signal.connect(Callable(self, "turned"))
		if !t.moved_signal.is_connected(Callable(self, "moved")):
			t.moved_signal.connect(Callable(self, "moved"))
		if !t.collision_signal.is_connected(Callable(self, "moved")):
			t.collision_signal.connect(Callable(self, "moved"))
		t.move_from_event = true
		t.anim_tree.active = true
		t.set_physics_process(false)
		await SignalManager.EVENT.add_cmd_move.emit(self)
		await move()
		SignalManager.CMD.finished.emit()
		
func force_exec(moves:Array[Directions]):
	move_commands = moves
	SignalManager.CMD.started.emit()
	SignalManager.CMD.waited.connect(Callable(self, "waited"))
	print(str(name) + " started")
	
	if move_commands != []:
		print("target ", t)	
		if t.is_in_group("Player"):
			type = ""
		elif t.is_in_group("Event"):
			type = "_event"
		if !t.turned_signal.is_connected(Callable(self, "turned")):
			t.turned_signal.connect(Callable(self, "turned"))
		if !t.moved_signal.is_connected(Callable(self, "moved")):
			t.moved_signal.connect(Callable(self, "moved"))
		if !t.collision_signal.is_connected(Callable(self, "moved")):
			t.collision_signal.connect(Callable(self, "moved"))
		t.move_from_event = true
		t.anim_tree.active = true
		t.set_physics_process(false)
		await SignalManager.EVENT.add_cmd_move.emit(self)
		await move()
		SignalManager.CMD.finished.emit()
	
func _physics_process(delta):
#	if is_turning_command():
#		set_physics_process(false)
	#print("pipo")
	if t.move_state == t.MoveState.TURNING:
#		if is_turning_command():
#			set_physics_process(true)
		return
	elif t.is_moving == false:
		await t.process_player_movement_input()
	elif t.input_direction != Vector2.ZERO:
		t.anim_state.travel("Walk")
		await  t.move(delta)
	else:
		t.anim_state.travel("Idle")
		t.is_moving = false
		
func move():
	actual_command = move_commands[index]
#	print(CONST.InputActions[actual_command])
	if is_turning_command():
		var dir = CONST.InputActions[actual_command-4]
		#print("turn ", t.input_direction)
		t.continued = false
		if need_to_turn(): #Si ja està "turned" (ja mira cap a la direcció que toca) ens saltem l'acció
			await remote_input(dir, 0.15)
		else:
			turned()
	elif is_waiting_command():
		var time = CONST.InputActions[actual_command].right(4)
	#	print(time)
		await wait(time.to_float())
		SignalManager.CMD.waited.emit()
		#emit_signal("waited_signal")
	else:
		var dir = CONST.InputActions[actual_command]
		#print("move", t.input_direction)
		t.continued = true
		await remote_input(dir)

#S'executa quan el personatge acaba de fer un moviment, amb una acció left/right/up/down
func moved():
	if !is_turning_command():
		if index != move_commands.size()-1:
			index += 1
			t.continued = false
			#print("cmd moved")
			Input.action_release("ui_"+CONST.InputActions[actual_command]+type)
			t.input_direction = Vector2(0, 0)
	
			await move()
		else:
			finish_cmd_move()

#S'executa quan el personatge acaba de mirar cap un altre costat, amb una acció turn_
func turned():
	if is_turning_command():
		if index != move_commands.size()-1:
			index += 1
			t.continued = false
			#print("cmd turned")
			Input.action_release("ui_"+CONST.InputActions[actual_command-4]+type)
			t.input_direction = Vector2(0, 0)
			await move()

		else:
			finish_cmd_move()
			
func waited():
	if is_waiting_command():
		if index != move_commands.size()-1:
			index += 1
			t.continued = false
			#print("cmd waited")
			t.input_direction = Vector2(0, 0)
			await move()

		else:
			finish_cmd_move()

func wait(time):
	#print("wait")
	var timer = Timer.new()
	timer.set_one_shot(false)
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.set_wait_time(time)
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func is_turning_command():
	if index <= move_commands.size()-1:
		return "turn" in CONST.InputActions[move_commands[index]]
	else:
		return false
		
func is_waiting_command():
	if index <= move_commands.size()-1:
		return "wait" in CONST.InputActions[move_commands[index]]
	else:
		return false

func finish_cmd_move():

	t.input_direction = Vector2(0, 0)
	#move_commands = []
	index = 0
	if t.is_in_group("Player"):
		t.move_from_event = false
		t.set_physics_process(true)
	t.turned_signal.disconnect(Callable(self, "turned"))
	t.moved_signal.disconnect(Callable(self, "moved"))
	t.collision_signal.disconnect(Callable(self, "moved"))
	SignalManager.CMD.waited.disconnect(Callable(self, "waited"))
	
	t.anim_state.travel("Idle")
	t.is_moving = false
	set_physics_process(false)
	t = null
	#set_physics_process(false)
	print(str(name) + " finished")
	SignalManager.EVENT.delete_cmd_move.emit(self)
	#SignalManager.CMD.finished.emit()
	
func remote_input(dir, time = 0.2):
	#print("wait")
	set_physics_process(true)
	t.input_direction = CONST.MoveInput[dir]
	
	var timer = Timer.new()
	timer.set_one_shot(false)
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.set_wait_time(time)
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

func need_to_turn():
	return t.facing_direction != actual_command-4
