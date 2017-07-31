extends Area2D

func _ready():
	set_process(true)
	pass

func _process(delta):
	set_pos(get_pos() + Vector2(600,0) * delta)


func _on_bottle_area_enter( area ):
	if area.get_name().find("npc") >= 0:
		if not area.is_dead():
			queue_free()
			area.dead()
