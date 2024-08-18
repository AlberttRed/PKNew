class_name BattleAnimationPlayer extends AnimationPlayer

signal finished

var currentAnimationName :String
var currentAnimation :Animation
var animParams :Dictionary
var root

var temporary: bool = false

func _enter_tree():
	animation_finished.connect(_on_animation_finished)
	
func _exit_tree():
	animation_finished.disconnect(_on_animation_finished)

func playAnimation(name: StringName = "", _animParams:Dictionary = {}, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	SignalManager.BATTLE.playAnimation.emit(name, animParams, get_node(root_node))
	
#func getAnimation(name:String) -> Animation:
	#var anim : Animation = null
	#for libName:String in get_animation_library_list():
		#var library:AnimationLibrary = get_animation_library(libName)
		#if library!=null && library.has_animation(name):
			#anim = library.get_animation(name)
			#currentAnimationName = libName+"/"+name
			##if anim.has_meta("Script"):
				##
				##anim.set_script(load(anim.get_meta("Script")))
			#break
	#return anim



func _on_animation_finished(anim_name):
	finish()

func finish():
	currentAnimationName=""
	if currentAnimation!=null and currentAnimation.get_script() != null:
		currentAnimation.freeAnimation()
	currentAnimation = null
	finished.emit(self)

#
#func setAnimation():
	#if currentAnimation!=null and currentAnimation.has_method("setAnimation"):
		#currentAnimation.setAnimation(get_parent(), animParams)
	#
#func animationFinished():
	#SignalManager.ANIMATION.finished_animation.emit()
