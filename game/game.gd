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

onready var number_texture_0 = preload("res://game/assets/number_signs_0.png")
onready var number_texture_1 = preload("res://game/assets/number_signs_1.png")
onready var number_texture_2 = preload("res://game/assets/number_signs_2.png")
onready var number_texture_3 = preload("res://game/assets/number_signs_3.png")
onready var number_texture_4 = preload("res://game/assets/number_signs_4.png")
onready var number_texture_5 = preload("res://game/assets/number_signs_5.png")
onready var number_texture_6 = preload("res://game/assets/number_signs_6.png")
onready var number_texture_7 = preload("res://game/assets/number_signs_7.png")
onready var number_texture_8 = preload("res://game/assets/number_signs_8.png")
onready var number_texture_9 = preload("res://game/assets/number_signs_9.png")
onready var number_texture_container = [
	number_texture_0, 
	number_texture_1, 
	number_texture_2, 
	number_texture_3, 
	number_texture_4, 
	number_texture_5, 
	number_texture_6, 
	number_texture_7, 
	number_texture_8, 
	number_texture_9
]

onready var number_sign_1 = get_node("number_signs/sign_1")
onready var number_sign_2 = get_node("number_signs/sign_2")
onready var number_sign_3 = get_node("number_signs/sign_3")
onready var number_sign_4 = get_node("number_signs/sign_4")
onready var number_sign_container = [
	number_sign_1,
	number_sign_2,
	number_sign_3,
	number_sign_4
]

onready var living_texture = preload("res://game/assets/player_8.png")
onready var dead_texture = preload("res://game/assets/player_9.png")

onready var life_1_sprite = get_node("lives/life_1")
onready var life_2_sprite = get_node("lives/life_2")
onready var life_3_sprite = get_node("lives/life_3")

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

onready var sample_player = get_node("sample_player")

onready var score_label = get_node("score_label")

onready var level_label = get_node("level_label")
onready var level_effect = get_node("level_effect")

enum player_states {IDLE, RUNNING, PICKING, THROWING}
var player_state = IDLE

var got_bottle = false
var level = 1
var npc_amount = 40
var y_position = 1
var x_position = 0
var player_at_end = false

var available_bottles = [0, 0, 0, 0]

var lifes = 3
var score = 0

func _ready():
	set_process(true)
	set_process_input(true)
	move_player()
	randomize()
	start_level()
	update_number_signs()
	update_lifes()
	show_level()
	npc_spawn_timer.start()
	sample_player.play("background_1")
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
		player.play_idle(got_bottle)
		
	if npc_amount == 0 and npc_container.get_children().size() == 0:
		level += 1
		start_level()
		show_level()

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
		bottle.connect("bottle_picked_up", self, "_on_bottle_picked_up")
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
			update_number_signs()
		elif available_bottles[y_position-1] <0:
			got_bottle = false
	if x_position < 5:
		player_at_end = true
	elif x_position > 5:
		player_at_end = false
	print(available_bottles)
		
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
	npc_amount = level * 2 + 20
	var median = npc_amount / 4
	var sum = 0 
	for i in range(3):
		var bottles_in_this_box = median + (randi() % 5 - 2)
		available_bottles[i] = bottles_in_this_box
		sum += bottles_in_this_box
	
	available_bottles[3] = npc_amount - sum
	
	update_number_signs()
	
	
	
	#available_bottles[0] = 1
	#available_bottles[1] = 2
	#available_bottles[2] = 3
	#available_bottles[3] = 4
	
	pass

func _on_life_lost():
	lifes -= 1 
	print("life_lost")
	update_lifes()
	

func _on_npc_spawn_timer_timeout():
	if npc_amount > 0:
		var npc = npc_template.instance()
		var random_npc_spawn = randi()%4+1
		npc.connect("life_lost", self, "_on_life_lost")
		if random_npc_spawn == 1:
			npc.set_pos(npc_pos_1.get_pos())
			npc_amount -= 1
		elif random_npc_spawn == 2:
			npc.set_pos(npc_pos_2.get_pos())
			npc_amount -= 1
		elif random_npc_spawn == 3:
			npc.set_pos(npc_pos_3.get_pos())
			npc_amount -= 1
		elif random_npc_spawn == 4:
			npc.set_pos(npc_pos_4.get_pos())
			npc_amount -= 1
		npc_container.add_child(npc)
		print(npc_amount)
	elif npc_amount < 1:
		pass

func game_over():
	print("game_over")
	lifes -= 1
	update_lifes()
	
func update_number_signs():
	for i in range(4):
		if available_bottles[i] <= 9:
			number_sign_container[i].set_texture(number_texture_container[available_bottles[i]])
		else:
			number_sign_container[i].set_texture(number_texture_container[9])
	print(available_bottles)
	
func life_lost():
	lifes -= 1
	
func update_lifes():
	if lifes == 3:
		life_1_sprite.set_texture(living_texture)
		life_2_sprite.set_texture(living_texture)
		life_3_sprite.set_texture(living_texture)
	elif lifes == 2:
		life_1_sprite.set_texture(living_texture)
		life_2_sprite.set_texture(living_texture)
		life_3_sprite.set_texture(dead_texture)
	elif lifes == 1:
		life_1_sprite.set_texture(living_texture)
		life_2_sprite.set_texture(dead_texture)
		life_3_sprite.set_texture(dead_texture)
	else:
		life_1_sprite.set_texture(dead_texture)
		life_2_sprite.set_texture(dead_texture)
		life_3_sprite.set_texture(dead_texture)
	
	if lifes == 0:
		game_over()
		print("you lost")
		
		
func show_level():
	level_label.set_text("LEVEL %d" % level)
	level_effect.interpolate_property(level_label, 'visibility/opacity', 1.0, 0.0, 2.0, Tween.TRANS_QUAD, Tween.EASE_OUT)
	level_effect.start()
	
func update_score():
	score_label.set_text("SCORE %d" % score)

func _on_bottle_picked_up():
	score += 100
	update_score()