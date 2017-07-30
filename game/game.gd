extends Node

onready var npc_pos_1 = get_node("npc_pos_1")
onready var npc_pos_2 = get_node("npc_pos_2")
onready var npc_pos_3 = get_node("npc_pos_3")
onready var npc_pos_4 = get_node("npc_pos_4")
onready var player_pos_1 = get_node("player_pos_1")
onready var player_pos_2 = get_node("player_pos_2")
onready var player_pos_3 = get_node("player_pos_3")
onready var player_pos_4 = get_node("player_pos_4")
onready var bottle_pos_1 = get_node("bottle_pos_1")
onready var player = get_node("player")
onready var jump_timer = get_node("jump_timer")
onready var bottle_container = get_node("bottle_container")
onready var npc_container = get_node("npc_container")

var bottle_template = preload("res://game/powder_box/bottle.tscn")
var npc_template = preload("res://game/npc/npc.tscn")

var got_bottle = true
var y_position = 1
var x_position = 0

func _ready():
	set_process(true)
	set_process_input(true)
	move_player()
	
	var bottle = bottle_template.instance()
	bottle.set_pos(bottle_pos_1.get_pos())
	bottle_container.add_child(bottle)

	var npc = npc_template.instance()
	npc.set_pos(Vector2(1000, 300))
	npc_container.add_child(npc)

func _process(delta):
	if Input.is_action_pressed("player_right"):
		x_position = min(800, x_position + 400 * delta)
	if Input.is_action_pressed("player_left"):
		x_position = max(0, x_position - 400 * delta)
	move_player()
	print(got_bottle)
func _input(event):
	if event.is_action_pressed("player_down") and jump_timer.get_time_left() == 0:
		y_position = min(4, y_position + 1)
		x_position = 0
		jump_timer.start()
		#move_player()
	if event.is_action_pressed("player_up") and jump_timer.get_time_left() == 0:
		y_position = max(1, y_position - 1)
		x_position = 0
		jump_timer.start()
	if event.is_action_pressed("player_fire") and got_bottle:
		bottle_template.instance()
		got_bottle = false
func move_player():
	if y_position == 1:
		player.set_pos(player_pos_1.get_pos() + Vector2(x_position, 0))
	elif y_position == 2:
		player.set_pos(player_pos_2.get_pos() + Vector2(x_position, 0))
	elif y_position == 3:
		player.set_pos(player_pos_3.get_pos() + Vector2(x_position, 0))
	elif y_position == 4:
		player.set_pos(player_pos_4.get_pos() + Vector2(x_position, 0))
		