extends Area2D

onready var sprite = get_node("sprite")
onready var bottle = get_node("bottle")

var animating = false




	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

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
	#sprite.set_frame(0)
	sprite.play("run")
	pass
	
func play_picking():
	sprite.set_flip_h(false)
	bottle.hide()
	animating = true
	#sprite.set_frame(0)
	sprite.play("pick up")
	
func play_throwing():
	sprite.set_flip_h(false)
	bottle.hide()
	animating = true
	#sprite.set_frame(0)
	sprite.play("throw")
	
func _on_sprite_finished():
	animating = false
	
func is_animating():
	return animating	
