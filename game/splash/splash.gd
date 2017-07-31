extends Node

onready var text_1 = get_node("text_1")
onready var text_2 = get_node("text_2")
onready var text_1_effect = get_node("text_1_effect")
onready var text_2_effect = get_node("text_2_effect")
onready var sample_player = get_node("sample_player")

var lines =	["IT IS BRENDA'S FIRST DAY ON THE JOB     WORKING FOR THE MAN",
"AND THE BOSS DECIDED IT WAS TIME FOR    A SALE!",
"TOO BAD THE AD STATED A 100% DISCOUNT   INSTEAD OF 10%...",
"SO BRENDA HAS TO TRY TO KEEP UP WITH    THE DEMAND...",
"...",
"PROGRAMMING, GRAPHICS AND SOUND BY      ANDERS, BENJAMIN AND WILLIAM"]

var line_index = 0
var fading_in = true
const FADE_TIMEOUT = 2

func _ready():
	sample_player.play("intro")
	set_text()
	text_1_effect.interpolate_property(text_1, 'visibility/opacity', 0.0, 1.0, FADE_TIMEOUT, Tween.TRANS_QUAD, Tween.EASE_OUT)
	text_2_effect.interpolate_property(text_2, 'visibility/opacity', 0.0, 1.0, FADE_TIMEOUT, Tween.TRANS_QUAD, Tween.EASE_OUT)
	text_1_effect.start()
	text_2_effect.start()
		
func set_text():
	text_1.set_text(lines[line_index].left(40))
	if lines[line_index].length() > 40:
		text_2.set_text(lines[line_index].right(40))
	else:
		text_2.set_text("")
		
func _on_text_1_effect_tween_complete( object, key ):
	if fading_in:
		fading_in = false
		text_1_effect.interpolate_property(text_1, 'visibility/opacity', 1.0, 0.0, FADE_TIMEOUT, Tween.TRANS_QUAD, Tween.EASE_OUT)
		text_1_effect.start()

		text_2_effect.interpolate_property(text_2, 'visibility/opacity', 1.0, 0.0, FADE_TIMEOUT, Tween.TRANS_QUAD, Tween.EASE_OUT)
		text_2_effect.start()
	else:
		fading_in = true
		line_index += 1
		if line_index >= lines.size():
			line_index = 0
		set_text()
		
		text_1_effect.interpolate_property(text_1, 'visibility/opacity', 0.0, 1.0, FADE_TIMEOUT, Tween.TRANS_QUAD, Tween.EASE_OUT)
		text_1_effect.start()

		text_2_effect.interpolate_property(text_2, 'visibility/opacity', 0.0, 1.0, FADE_TIMEOUT, Tween.TRANS_QUAD, Tween.EASE_OUT)
		text_2_effect.start()
