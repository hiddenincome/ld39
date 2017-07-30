extends Area2D


onready var move_timer = get_node("move_timer")
onready var sprite = get_node("sprite")
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var state = 0

func dead():
	move_timer.stop()
	sprite.set_frame(2)

func _ready():
	
	# Called every time the node is added to the scene.
	# Initialization here
	move_timer.start()

func _process(delta):
	pass

func _on_move_timer_timeout():
	
	state += 1
	if state > 7:
		state = 0
		
	if state == 0:
		pass
	elif state == 1:
		pass
	elif state == 2:
		pass
	elif state == 3:
		set_pos(get_pos() + Vector2(-15,0))
		sprite.set_frame(1)
	elif state == 4:
		set_pos(get_pos() + Vector2(-15,0))
	elif state == 5:
		set_pos(get_pos() + Vector2(-15,0))
		sprite.set_frame(0)
	elif state == 6:
		set_pos(get_pos() + Vector2(-15,0))
	elif state == 7:
		pass
