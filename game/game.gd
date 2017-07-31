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
onready var box_pos_1 = get_node("box_pos_1")
onready var box_pos_2 = get_node("box_pos_2")
onready var box_pos_3 = get_node("box_pos_3")
onready var box_pos_4 = get_node("box_pos_4")


onready var box_positions = [
	box_pos_1,
	box_pos_2,
	box_pos_3,
	box_pos_4]
onready var npc_spawn_timer = get_node("npc_spawn_timer")

onready var bottle_positions = [
	bottle_pos_1,
	bottle_pos_2,
	bottle_pos_3,
	bottle_pos_4]

var bottle_template = preload("res://game/powder_box/bottle.tscn")
var npc_template = preload("res://game/npc/npc.tscn")

enum player_states {IDLE, RUNNING, PICKING, THROWING}
var player_state = IDLE
var enemy_total = 20

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
	npc_spawn_timer.start()
	randomize()
	#var bottle = bottle_template.instance()
	#bottle.set_pos(bottle_pos_1.get_pos())
	#bottle_container.add_child(bottle)


	

func _process(delta):
	if Input.is_action_pressed("player_right"):
		x_position = min(800, x_position + 400 * delta)
	if Input.is_action_pressed("player_left"):
		x_position = max(0, x_position - 400 * delta)
	move_player()
	#print(got_bottle)

	if player_state == PICKING:
		if not player.is_animating():
			player_state = IDLE
	if player_state == IDLE:
		player.play_idle()
		
		
				
func _input(event):
	if event.is_action_pressed("player_down") and jump_timer.get_time_left() == 0 and not player_state == PICKING:
		y_position = min(4, y_position + 1)
		x_position = 0
		jump_timer.start()
		#move_player()
	if event.is_action_pressed("player_up") and jump_timer.get_time_left() == 0 and not player_state == PICKING:
		y_position = max(1, y_position - 1)
		x_position = 0
		jump_timer.start()
	if event.is_action_pressed("player_fire") and got_bottle and player_at_end and not player_state == PICKING:
		var bottle = bottle_template.instance()
		bottle.set_pos(bottle_positions[y_position-1].get_pos())
		bottle_container.add_child(bottle)
		player.play_throwing()
		got_bottle = false
	elif event.is_action_pressed("player_fire") and not got_bottle and player_at_end:
		player_state = PICKING
		player.play_picking()
		if available_bottles[y_position-1] > 0:
			available_bottles[y_position-1] -= 1
			got_bottle = true
		elif available_bottles[y_position-1] <0:
			got_bottle = false
	if x_position < 5:
		player_at_end = true
	elif x_position > 5:
		player_at_end = false

		
func move_player():
	if player_state == IDLE or player_state == RUNNING:
		if y_position == 1:
			player.set_pos(player_pos_1.get_pos() + Vector2(x_position, 0))
		elif y_position == 2:
			player.set_pos(player_pos_2.get_pos() + Vector2(x_position, 0))
		elif y_position == 3:
			player.set_pos(player_pos_3.get_pos() + Vector2(x_position, 0))
		elif y_position == 4:
			player.set_pos(player_pos_4.get_pos() + Vector2(x_position, 0))
	elif player_state == PICKING:
		player.set_pos(box_positions[y_position-1].get_pos())


func start_level():
	# Fill up the bottles
	
	available_bottles[0] = 1
	available_bottles[1] = 2
	available_bottles[2] = 3
	available_bottles[3] = 4
	
	pass

func _on_npc_spawn_timer_timeout():
	var npc = npc_template.instance()
	var random_npc_spawn = randi()%4+1
	if random_npc_spawn == 1:
		 npc.set_pos(npc_pos_1.get_pos())
	elif random_npc_spawn == 2:
		 npc.set_pos(npc_pos_2.get_pos())
	elif random_npc_spawn == 3:
		 npc.set_pos(npc_pos_3.get_pos())
	elif random_npc_spawn == 4:
		 npc.set_pos(npc_pos_4.get_pos())
	npc_container.add_child(npc)

func game_over():
	print("game_over")
	

func _on_game_over_1_area_enter( area ):
	if area.get_name().find("npc") >= 0:
		game_over()
		
func _on_game_over_2_area_enter( area ):
	if area.get_name().find("npc") >= 0:
		game_over()
		
func _on_game_over_3_area_enter( area ):
	if area.get_name().find("npc") >= 0:
		game_over()

func _on_game_over_4_area_enter( area ):
	if area.get_name().find("npc") >= 0:
		game_over()