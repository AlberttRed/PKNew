class_name BattleAnimationPlayer extends AnimationPlayer

signal finished

var currentAnimationName :String
var currentAnimation :Animation
var animParams :Dictionary
var root

var temporary: bool = false

func playAnimation(name: StringName = "", _animParams:Dictionary = {}, custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	var animPlayer : BattleAnimationPlayer = null
	animParams = _animParams
	#if super.is_playing():
	animPlayer = duplicate()
	animPlayer.temporary = true
	#animPlayer.animation_finished.disconnect(Callable(self, "_on_animation_finished"))
	#animPlayer.animation_finished.connect(Callable(animPlayer, "_on_animation_finished"))
	#var parent = get_node(root_node)
		
	root.add_child(animPlayer)
	#else:
		#animPlayer = self
		
	
	animPlayer.currentAnimation = getAnimation(name)
	#print(animPlayer.currentAnimation.resource_name)

	if animPlayer.currentAnimation == null:
		assert(false, "Animation " + name + " does not exist.")
		return
		#
	if animPlayer.currentAnimation.has_method("setAnimation"):#get_script() != null:
		animPlayer.currentAnimation.setAnimation(root, animParams)
	
	#if animPlayer.currentAnimation.has_meta("Script"):
		#animPlayer.currentAnimation.set_script(animPlayer.currentAnimation.get_meta("Script"))
		#animPlayer.currentAnimation.setAnimation(get_parent(), animParams)

	animPlayer.play(currentAnimationName, custom_blend, custom_speed, from_end)
	await animPlayer.animation_finished
	
func getAnimation(name:String) -> Animation:
	var anim : Animation = null
	for libName:String in get_animation_library_list():
		var library:AnimationLibrary = get_animation_library(libName)
		if library!=null && library.has_animation(name):
			anim = library.get_animation(name)
			currentAnimationName = libName+"/"+name
			#if anim.has_meta("Script"):
				#
				#anim.set_script(load(anim.get_meta("Script")))
			break
	return anim



func _on_animation_finished(anim_name):
	currentAnimationName=""
	if currentAnimation!=null and currentAnimation.get_script() != null:
		currentAnimation.freeAnimation()
	currentAnimation = null
	if temporary:
		queue_free()

func setAnimation():
	if currentAnimation!=null and currentAnimation.has_method("setAnimation"):
		currentAnimation.setAnimation(get_parent(), animParams)
	
func animationFinished():
	SIGNALS.ANIMATION.finished_animation.emit()
