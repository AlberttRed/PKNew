extends RichTextLabel

 
@export var font_size : int
@export var font_color : Color
@export var outline_color : Color
@export var text_font :Font #DynamicFont
@export var block_outline : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.text = text
	set("theme_override_fonts/normal_font", text_font)
	$Outline.set("theme_override_fonts/normal_font", text_font)
	set("theme_override_font_sizes/normal_font_size", font_size)
	$Outline.set("theme_override_font_sizes/normal_font_size", font_size)
	set("theme_override_colors/default_color", font_color)
	$Outline.set("theme_override_colors/default_color", font_color)
	set("theme_override_colors/font_shadow_color", outline_color)
	$Outline.set("theme_override_colors/font_shadow_color", outline_color)
	if block_outline:
		$Outline.position = Vector2(0, 0)
		$Outline.size = size
	#theme_override_fonts/normal_font	
		
func setText(_text):
	text = _text
	$Outline.text = _text
