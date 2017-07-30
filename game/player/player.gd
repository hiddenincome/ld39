extends Area2D

onready var sprite = get_node("sprite")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func play_idle():
	pass
	
func play_running():
	pass
	
func play_picking():
	sprite.set_frame(0)
	sprite.play("pick up")
	
func play_throwing():
	sprite.set_frame(0)
	sprite.play("throw")
	
	