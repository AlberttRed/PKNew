extends RichTextLabel

signal line_displayed
signal lines_displayed
signal text_completed

const LINE_CHARS = 36
const VISIBLE_CHARS_LIMIT = 72

var lastLine: int = 0
var nextLineStop:int = 2
var actualLine:int = 0

var isLastLine:bool:
	get:
		return actualLine == get_line_count()
		
var messageHasFinished:bool:
	get:
		return visible_characters == -1 or visible_characters == get_total_character_count()
 
@export var font_size : int
@export var font_color : Color
@export var outline_color : Color
@export var text_font :Font #DynamicFont
@export var block_outline : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set("theme_override_fonts/normal_font", text_font)
	$Outline.set("theme_override_fonts/normal_font", text_font)
	$Outline2.set("theme_override_fonts/normal_font", text_font)
	set("theme_override_font_sizes/normal_font_size", font_size)
	$Outline.set("theme_override_font_sizes/normal_font_size", font_size)
	$Outline2.set("theme_override_font_sizes/normal_font_size", font_size)
	set("theme_override_colors/default_color", font_color)
	$Outline.set("theme_override_colors/default_color", font_color)
	$Outline2.set("theme_override_colors/default_color", font_color)
	set("theme_override_colors/font_shadow_color", outline_color)
	$Outline.set("theme_override_colors/font_shadow_color", outline_color)
	$Outline2.set("theme_override_colors/font_shadow_color", outline_color)
	if block_outline:
		$Outline.position = Vector2(0, 0)
		$Outline.size = size
		$Outline2.position = Vector2(0, 0)
		$Outline2.size = size
		
func setText(_text):
	text = _text

func updateNextLine():
	nextLineStop += 1
	
func reset():
	lastLine = 0
	nextLineStop = 0
	visible_ratio = 0
	
func _set(name, value):
	match name:
		"text":
			text = value
			$Outline.text = value
			$Outline2.text = value
		"visible_characters":
			var nextLine = 0
			visible_characters = value
			$Outline.visible_characters = value
			$Outline2.visible_characters = value
			actualLine = get_character_line(visible_characters) + 1
			nextLine = get_character_line(visible_characters+1) + 1
			if nextLine == 0:
				nextLine = actualLine
			if messageHasFinished or nextLine != actualLine:
				line_displayed.emit()
				lastLine = actualLine
