extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const CAP_SPEED = 500
const MOVE_SPEED = CAP_SPEED

var velocity = Vector2()
var is_dead = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$anim.play("flying")
	is_dead = false
	pass
	
func _check_if_dead():
	if position.x < - $Sprite.texture.get_size().x:
		print("alienship dead")
		return true
	return false
	
func _handle_movement():
	if Input.is_action_pressed("up"):
		velocity.y -= MOVE_SPEED
	
	if Input.is_action_pressed("down"):
		velocity.y += MOVE_SPEED
		
	if Input.is_action_just_released("up") or Input.is_action_just_released("down"):
		velocity.y /= 8
		
	# Check limits
	if velocity.y >= CAP_SPEED:
		velocity.y = CAP_SPEED
	if velocity.y <= -CAP_SPEED:
		velocity.y = -CAP_SPEED
		
	move_and_slide(velocity, Vector2(0, -1), 5, 20)
	pass

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	if not _check_if_dead() and get_node("/root/main_scn_root").is_alien:
		_handle_movement()
	pass
