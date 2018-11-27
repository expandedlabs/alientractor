extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const JUMP_CUT_OFF = 1200
const GRAVITY = -JUMP_CUT_OFF * 2


var anim = "backward"
var jumping = false
var velocity = Vector2()
var is_dead

func _ready():
	$anim.play(anim)
	is_dead = false
	pass
	
func _check_if_dead():
	if position.x < -$body.texture.get_size().x /2:
		return true
	return false
	
func _handle_movement(delta):
	
	#Check for jump
	if (Input.is_action_pressed("up") or Input.is_action_pressed("down")) and is_on_ceiling():
		velocity.y = JUMP_CUT_OFF
		jumping=true
		
	# Prevent double jumping 
	if velocity.y <= 0 and is_on_ceiling(): 
		jumping = false
		
	# Cap velocity
	if velocity.y <= -JUMP_CUT_OFF:
		velocity.y = -JUMP_CUT_OFF
		
		
	
func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	if not _check_if_dead():
		#Add gravity
		velocity.y += GRAVITY * delta
		
		if not get_node("/root/main_scn_root").is_alien:
			_handle_movement(delta)
			
		#print("%s and %s" % [velocity.y, jumping])
		move_and_slide(velocity, Vector2(0, -1), 5, 20)

	pass