extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const JUMP_CUT_OFF = 1200
const GRAVITY = JUMP_CUT_OFF * 2


var anim = "forward"
var jumping = false
var velocity = Vector2()
onready var is_dead = false
onready var origin_position = position

func _ready():
	$anim.play(anim)
	$audio.get_stream().set_loop(false);
	pass
	
func _restart():
	is_dead = false
	velocity = Vector2()
	position = origin_position
	pass
	
func _check_if_dead():
	if position.x < -$body.texture.get_size().x /2:
		return true
	return false
	
func _handle_movement(delta):
	
	#Check for jump
	if (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		velocity.y = -JUMP_CUT_OFF / 2
		jumping=true
		
		
	# Prevent double jumping 
	if velocity.y <= 0 and is_on_floor(): 
		jumping = false
		$audio.play()
		print("yes");
		
	# Cap velocity
	if velocity.y <= -JUMP_CUT_OFF:
		velocity.y = 0
		
		
	
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