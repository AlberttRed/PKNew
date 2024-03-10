extends Label

 
@export var font_size: int
@export var font_color: Color
@export var outline_color: Color
@export var text_font: Font
@export var block_outline: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$Outline.text = text
	set("theme_override_fonts/font", text_font)
	$Outline.set("theme_override_fonts/font", text_font)
	set("theme_override_font_sizes/font_size", font_size)
	$Outline.set("theme_override_font_sizes/font_size", font_size)
	set("theme_override_colors/font_color", font_color)
	$Outline.set("theme_override_colors/font_color", font_color)
	set("theme_override_colors/font_shadow_color", outline_color)
	$Outline.set("theme_override_colors/font_shadow_color", outline_color)
	$Outline.layout_direction = layout_direction
	$Outline.layout_mode = layout_mode
	
	if block_outline:
		$Outline.position = Vector2(0, 0)
		$Outline.size = size
		$Outline.horizontal_alignment = horizontal_alignment


func setText(_text):
	text = _text
	$Outline.text = _text
