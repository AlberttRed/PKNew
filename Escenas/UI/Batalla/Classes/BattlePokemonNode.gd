extends Node2D


func doAnimation(animName:String):
	print(animName)
	
	#await load("res://Animaciones/Batalla/Pokemon/Classes/"+str(animName)+".gd").new(self).doAnimation()
