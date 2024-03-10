extends Node

class_name RemoteMovement

signal movement_finished
signal move_done
signal checked

enum Directions { LEFT, RIGHT, UP, DOWN, TURN_LEFT, TURN_RIGHT, TURN_UP, TURN_DOWN, WAIT025, WAIT050, WAIT1 }
enum Movement_Actions { WALK, TURN, COLLIDE }

var target : CharacterController
var action_to_check : Movement_Actions
var action_to_do : Movement_Actions
var actual_command : Directions

const INPUT_DIRECTIONS = { 
	0: Vector2(-1, 0), 	#LEFT
	1: Vector2(1, 0),	#RIGHT
	2: Vector2(0, -1),	#UP
	3: Vector2(0, 1)	#DOWN
 }

func _init(_target : CharacterController = null):
	if _target != null:
		target = _target
		set_physics_process(false)
		if !target.remote_turned_signal.is_connected(Callable(self, "checkTargetMove")):
			target.remote_turned_signal.connect(Callable(self, "checkTargetMove"))
		if !target.remote_moved_signal.is_connected(Callable(self, "checkTargetMove")):
			target.remote_moved_signal.connect(Callable(self, "checkTargetMove"))
		if !target.remote_collided_signal.is_connected(Callable(self, "checkTargetMove")):
			target.remote_collided_signal.connect(Callable(self, "checkTargetMove"))

func _ready():
	set_physics_process(false)
	
func move(commands : Array[Directions], randomMovement : bool = false):
	#target.add_child(self)
	#print("moves to do: " + str(commands))
	
	for dir in commands:
		if dir == Directions.LEFT or dir == Directions.RIGHT or dir == Directions.UP or dir == Directions.DOWN:
			await do_move(dir, randomMovement)
		elif dir == Directions.TURN_LEFT or dir == Directions.TURN_RIGHT or dir == Directions.TURN_UP or dir == Directions.TURN_DOWN:
			await do_turn(dir)
	#target.remove_child(self)
	#print("yup")
	movement_finished.emit()
	
	#func a (dir):
		

func do_move(dir, randomMovement : bool = false):
	actual_command = dir
	action_to_check	= Movement_Actions.WALK
	#print("action to do " + str(action_to_check))
	#print("event " + str(target.input_direction))
	#Comprovem que no colisiona, i que, en cas de ser moviment aleatori, estigui dins de la zona de Moviments dels NPCs. En cas contrari, no farà el moviment
	if (!randomMovement and !target.is_colliding(dir)) or (randomMovement and target.checkNextStepArea(dir) == "NPCMovementArea" and !target.is_colliding(dir)):
		#print("move " + target.name)
		target.input_direction = INPUT_DIRECTIONS[actual_command]
#	else:
#		target.input_direction = Vector2.ZERO
	
	#else:
		#print("i can't bro")	
	set_physics_process(true)
	
	#print("awaiting move from " + target.name)
	await move_done
	#print("move from " + target.name + " detected")
	
	target.input_direction = Vector2(0,0)
	target.anim_state.travel("Idle")
	target.is_moving = false
	set_physics_process(false)	
	
func do_turn(dir):
	actual_command = dir
	action_to_check	= Movement_Actions.TURN
	#print("action to do " + str(action_to_check))

	target.input_direction = INPUT_DIRECTIONS[actual_command-4]
	target.process_player_movement_input()
	
	var timer = Timer.new()
	timer.set_one_shot(false)
	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	timer.set_wait_time(0.2)
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()


	target.input_direction = Vector2(0,0)
	target.anim_state.travel("Idle")
	target.is_moving = false
	#set_physics_process(false)
	
#Aquesta funció connecta per senyal amb el moved_signal i el turned_signal del Target. D'aquesta manera sabrem
# el moviment que ha fet el Target correspón al moviment que volem.
func checkTargetMove(action : Movement_Actions):
	#print("action: " + str(action))

	if action == action_to_check or action == Movement_Actions.COLLIDE:
		move_done.emit()
	#else:
		#print("lol")
	checked.emit()

func _physics_process(_delta):
	if target.move_state == target.MoveState.TURNING:
		return
	elif target.is_moving == false:
		target.process_player_movement_input()
		if target.input_direction == Vector2.ZERO:
			#print(target.name + " move done")
			move_done.emit()
	elif target.input_direction != Vector2.ZERO:
		if target.running:
			target.anim_state.travel("Run")
		else:
			target.anim_state.travel("Walk")
		target.move(get_physics_process_delta_time())
	else:
		target.anim_state.travel("Idle")
		target.is_moving = false
