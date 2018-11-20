extends Node

# Move speed parameters
var move_speed = 1
const MAX_MOVE = 150
export var incr_speed = 0.1

# Switch between alien/car
var is_alien = true

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$game_timer.connect("timeout", self, "_on_game_timer_timeout", [incr_speed])
	pass
	
func _on_game_timer_timeout(value):
	move_speed += value
	if move_speed >= MAX_MOVE:
		move_speed = MAX_MOVE
	print("move speed: ", move_speed)
	pass # replace with function body


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if Input.is_action_just_pressed("flip"):
		is_alien = !is_alien
	pass
