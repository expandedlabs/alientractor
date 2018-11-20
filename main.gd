extends Node

# Game over
var gameover

# Move speed parameters
var move_speed = 1
const MAX_MOVE = 150
export var incr_speed = 0.1

# Switch between alien/car
var is_alien = true

# Block instance
var block_inst = preload("res://block.tscn")
var chance_spawn_percent = 50
var valid_top_locations = [ 20, 230, 460 ]
var valid_bot_locations = [ 600, 650, 800 ]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$game_timer.connect("timeout", self, "_on_game_timer_timeout", [incr_speed])
	$game_timer.connect("timeout", self, "_spawn_blocks")
	game_over = false
	pass
	
func _on_game_timer_timeout(value):
	move_speed += value
	if move_speed >= MAX_MOVE:
		move_speed = MAX_MOVE
	pass 
	
func rand_percent():
	# Probability [0, 100]
	return randi() % 101
	pass
	
func _spawn_blocks():
	_spawn_block(valid_top_locations)
	_spawn_block(valid_bot_locations)
	
func _spawn_block(possible_loc):	
	if(rand_percent() < chance_spawn_percent):
		var new_block = block_inst.instance()
		
		# Spawn new block
		new_block.position.x = 2000
		var rand_loc = rand_percent()
		var index = randi() % possible_loc.size()
		new_block.position.y = possible_loc[index]
			
		# Lower probability to spawn a new block
		chance_spawn_percent -= 1
		
		get_parent().add_child(new_block)
	else:
		# We didn't spawn a block increase probability by 1
		chance_spawn_percent += 1
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if $alien_ship._check_if_dead() and $red_car._check_if_dead():
		print("game over!")
	else:	
		if Input.is_action_just_pressed("flip"):
			if $alien_ship._check_if_dead():
				is_alien = false
			elif $red_car._check_if_dead():
				is_alien = true
			else:
				is_alien = !is_alien
	pass
