extends Area2D

onready var dead_move_timer = get_node("dead_move_timer")
onready var smoke = get_node("smoke")
onready var death_timer = get_node("death_timer")
onready var move_timer = get_node("move_timer")
onready var sprite = get_node("sprite")
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal life_lost
var animation_name = ""
var died = false
var state = 0
var npc_level = 1
var movement = -15

func dead():
	move_timer.stop()
	dead_move_timer.start()
	#movement = 15
	move_timer.set_wait_time(0.03)
	died = true
	smoke.show()
	smoke.play("smoke")
	sprite.set_frame(2)
	
func set_level(level):
	npc_level = level

func is_dead():
	return died
	#sprite.set_frame(2)
	
	
	#queue_free()
func _ready():
	set_process(true)
	move_timer.set_wait_time(clamp(0.1 - 0.01 * npc_level, 0.05, 0.1))
	animation_name = "npc_%d" % (randi() % 3 + 1)
	smoke.hide()
	sprite.set_animation(animation_name)
	
	# Called every time the node is added to the scene.
	# Initialization here
	move_timer.start()

func _process(delta):
	if is_dead():
		set_pos(get_pos() + Vector2(500 * delta, 0))
		if get_pos().x > 1024:
			queue_free()

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
		set_pos(get_pos() + Vector2(movement,0))
		sprite.set_frame(1)
	elif state == 4:
		set_pos(get_pos() + Vector2(movement,0))
	elif state == 5:
		set_pos(get_pos() + Vector2(movement,0))
		sprite.set_frame(0)
	elif state == 6:
		set_pos(get_pos() + Vector2(movement,0))
	elif state == 7:
		pass
		


	


func _on_sprite_finished():
	sprite.set_animation(animation_name)
	sprite.set_frame(2)
	death_timer.start()


func _on_dead_move_timer_timeout():
	
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
		set_pos(get_pos() + Vector2(15,0))
		sprite.set_frame(2)
	elif state == 4:
		set_pos(get_pos() + Vector2(15,0))
	elif state == 5:
		set_pos(get_pos() + Vector2(15,0))
		sprite.set_frame(2)
	elif state == 6:
		set_pos(get_pos() + Vector2(15,0))
	elif state == 7:
		pass


func _on_npc_area_enter( area ):
	if area.get_name().find("game_over_1") >= 0:
		emit_signal("life_lost")
		queue_free()
	elif area.get_name().find("game_over_2") >= 0:
		emit_signal("life_lost")
		queue_free()
	elif area.get_name().find("game_over_3") >= 0:
		emit_signal("life_lost")
		queue_free()
	elif area.get_name().find("game_over_4") >= 0:
		emit_signal("life_lost")
		queue_free()



