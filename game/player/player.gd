extends Area2D

onready var sprite = get_node("sprite")

var animating = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func play_idle():
	animating = true
	sprite.set_frame(0)
	sprite.play("idle")
	
func play_running():
	animating = true
	pass
	
func play_picking():
	animating = true
	sprite.set_frame(0)
	sprite.play("pick up")
	
func play_throwing():
	animating = true
	sprite.set_frame(0)
	sprite.play("throw")
	
func _on_sprite_finished():
	animating = false
	
func is_animating():
	return animating	
