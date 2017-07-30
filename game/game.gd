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
onready var bottle_pos_2 = get_node("bottle_pos_2")
onready var bottle_pos_3 = get_node("bottle_pos_3")
onready var bottle_pos_4 = get_node("bottle_pos_4")
onready var player = get_node("player")
onready var jump_timer = get_node("jump_timer")
onready var bottle_container = get_node("bottle_container")
onready var npc_container = get_node("npc_container")

onready var bottle_positions = [
	bottle_pos_1,
	bottle_pos_2,
	bottle_pos_3,
	bottle_pos_4]

var bottle_template = preload("res://game/powder_box/bottle.tscn")
var npc_template = preload("res://game/npc/npc.tscn")

var got_bottle = true
var y_position = 1
var x_position = 0
var player_at_end = false

var available_bottles = [0, 0, 0, 0]

func _ready():
	set_process(true)
	set_process_input(true)
	move_player()
	start_level()
	
	#var bottle = bottle_template.instance()
	#bottle.set_pos(bottle_pos_1.get_pos())
	#bottle_container.add_child(bottle)


	var npc = npc_template.instance()
	npc.set_pos(npc_pos_1.get_pos())
	npc_container.add_child(npc)

func _process(delta):
	if Input.is_action_pressed("player_right"):
		x_position = min(800, x_position + 400 * delta)
	if Input.is_action_pressed("player_left"):
		x_position = max(0, x_position - 400 * delta)
	move_player()
	#print(got_bottle)
	
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
	if event.is_action_pressed("player_fire") and got_bottle and player_at_end:
		var bottle = bottle_template.instance()
		bottle.set_pos(bottle_positions[y_position-1].get_pos())
		bottle_container.add_child(bottle)
		player.play_throwing()
		got_bottle = false
	elif event.is_action_pressed("player_fire") and not got_bottle and player_at_end:
		player.play_picking()
		got_bottle = true
	if x_position < 5:
		player_at_end = true
	elif x_position > 5:
		player_at_end = false
		
func move_player():
	if y_position == 1:
		player.set_pos(player_pos_1.get_pos() + Vector2(x_position, 0))
	elif y_position == 2:
		player.set_pos(player_pos_2.get_pos() + Vector2(x_position, 0))
	elif y_position == 3:
		player.set_pos(player_pos_3.get_pos() + Vector2(x_position, 0))
	elif y_position == 4:
		player.set_pos(player_pos_4.get_pos() + Vector2(x_position, 0))
		
func start_level():
	# Fill up the bottles
	
	available_bottles[0] = 1
	available_bottles[1] = 2
	available_bottles[2] = 3
	available_bottles[3] = 4
	
	pass
