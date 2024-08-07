extends BattlePokemonAnimation
#----------------------------------------------------
#	Animació que es mostra quan a un pokémon li pugen els stats
#----------------------------------------------------

const overlay:Texture2D = preload("res://Sprites/Batalla/Moves Animations/OverlayStatUp.png")
const animName = "Pokemon/STATUP"


func setAnimation(_root, animParams:Dictionary):
	var stat:CONST.STATS = animParams.get('Stat')
	var animation: Animation =  self
	var statTexture:CompressedTexture2D = null
	#Change overlay texture
	var track_index = animation.find_track("Sprite:material:shader_parameter/overlay", Animation.TYPE_VALUE)
	var key_id: int = animation.track_find_key(track_index, 0.0)
	
	#if stat == CONST.STATS.ATA:
	#overlay.set_size_override(overlay.get_size()*2)
	statTexture = overlay
		
	#animation.track_set_key_value(track_index, key_id, statTexture)

func freeAnimation():
	pass

