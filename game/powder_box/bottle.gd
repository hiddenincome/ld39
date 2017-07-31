extends Area2D

signal bottle_picked_up

var permanent_bottle = false
var bottle_moving = true

func _ready():
	set_process(true)

func _process(delta):
	if bottle_moving:
		set_pos(get_pos() + Vector2(600,0) * delta)

func set_permanent_bottle():
	permanent_bottle = true

func _on_bottle_area_enter(area):
	if area.get_name().find("npc") >= 0:
		if not area.is_dead():
			emit_signal("bottle_picked_up")
			area.dead()
			if not permanent_bottle:
				queue_free()
			else:
				bottle_moving = false
