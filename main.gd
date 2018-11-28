extends Node

# Game over
onready var gameover = false
onready var playing = false

# Move speed parameters
var move_speed = 1
const MAX_MOVE = 50
export var incr_speed = 0.1
onready var faster_spawnrate = 0

# Switch between alien/car
var is_alien = true
var arrow_anim = "down_up"

# Block instance
var block_inst = preload("res://block.tscn")
var menu_inst = preload("res://menu.tscn")
var chance_spawn_percent = 50
var valid_top_locations = [ 50, 230, 460 ]
var valid_bot_locations = [ 600, 650, 800 ]

# Score
onready var score = 0

# Menu
var showing_menu = false
var current_menu

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$game_timer.connect("timeout", self, "_on_game_timer_timeout", [incr_speed])
	$game_timer.connect("timeout", self, "_spawn_blocks")
	pass
	
func _show_menu():
	current_menu = menu_inst.instance()
	current_menu.get_node("CenterContainer/Play").connect("pressed", self, "_restart_main")
	get_parent().add_child(current_menu)
	showing_menu = true
	pass
	
	
func _restart_main():
	get_tree().call_group("main_scene_group", "_restart")
	is_alien = true
	playing = true
	
	score = 0
	faster_spawnrate = 0
	move_speed = 1
	chance_spawn_percent = 50
	arrow_anim = "down_up"
	$game_timer.wait_time = 1
	$arrow.get_node("anim").play("down_up")
	
	get_parent().remove_child(current_menu)
	showing_menu = false	
	$score_label.set_text(str("Score: ", 0))
	$game_timer.start()
	
	pass
	
func _incr_score(value):
	score += value
	$score_label.set_text(str("Score: ", score))
	pass
	
func _on_game_timer_timeout(value):
	move_speed += value
	if move_speed >= MAX_MOVE:
		move_speed = MAX_MOVE
		
	faster_spawnrate += 1
	if faster_spawnrate % 5 == 0:
		$game_timer.wait_time -= 0.05
		chance_spawn_percent -= 1
		$game_timer.stop()
		$game_timer.start()
	pass 
	
func rand_percent():
	# Probability [0, 100]
	return randi() % 101
	pass
	
func _spawn_blocks():	
	var score_val = 1 if not $alien_ship._check_if_dead() else 0
	if(rand_percent() > chance_spawn_percent):
		_spawn_block(valid_top_locations, score_val)
		
	score_val = 1 if not $red_car._check_if_dead() else 0
	if(rand_percent() > chance_spawn_percent):
		_spawn_block(valid_bot_locations, score_val)
	
func _spawn_block(possible_loc, score_val):	
	var new_block = block_inst.instance()
	
	# Spawn new block
	new_block.position.x = 2000
	var rand_loc = rand_percent()
	var index = randi() % possible_loc.size()
	new_block.position.y = possible_loc[index]
	
	# Connect signal
	
	new_block.connect("block_disappear", self, "_incr_score", [score_val])
	new_block.add_to_group("main_scene_group")
				
	get_parent().add_child(new_block)
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if playing:
		if $alien_ship._check_if_dead() and $red_car._check_if_dead():
			print("game over!")
			playing = false
			$game_timer.stop()
			move_speed = 0
		else:	
			if Input.is_action_just_pressed("flip"):
				var new_anim
				if $alien_ship._check_if_dead():
					is_alien = false
				elif $red_car._check_if_dead():
					is_alien = true
				else:
					is_alien = !is_alien
				
				new_anim = "down_up"  if is_alien  else "up_down"
				if new_anim != arrow_anim:
					arrow_anim = new_anim
					$arrow.get_node("anim").play(arrow_anim)
				
				
	elif not showing_menu:
		_show_menu()
	pass
