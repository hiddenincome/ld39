extends Area2D

onready var sprite = get_node("sprite")
onready var bottle = get_node("bottle")
onready var explode = get_node("explode")
onready var player_effect = get_node("player_effect")

var animating = false
var alive = true

func _ready():
	pass

func play_explode():
	explode.show()
	explode.set_frame(0)
	explode.play("explode")
	player_effect.interpolate_property(sprite, 'visibility/opacity', 1.0, 0.0, 2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	player_effect.interpolate_property(bottle, 'visibility/opacity', 1.0, 0.0, 2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	player_effect.start()

func play_idle(has_bottle):
	sprite.set_flip_h(false)
	if has_bottle:
		bottle.show()
	else:
		bottle.hide()
	animating = true
	#sprite.set_frame(0)
	sprite.play("idle")
	
func play_running(right):
	sprite.set_flip_h(not right)
	bottle.hide()
	animating = true
	sprite.play("run")
	
func play_picking():
	sprite.set_flip_h(false)
	bottle.hide()
	animating = true
	sprite.play("pick up")
	
func play_throwing():
	sprite.set_flip_h(false)
	bottle.hide()
	animating = true
	sprite.play("throw")
	
func _on_sprite_finished():
	animating = false
	
func is_animating():
	return animating	

func _on_explode_finished():
	explode.hide()

func _on_player_effect_tween_complete(object, key):
	if alive:
		sprite.set_opacity(1.0)
		bottle.set_opacity(1.0)
	
func set_alive(a):
	alive = a
	if alive:
		sprite.set_opacity(1.0)
		bottle.set_opacity(1.0)
