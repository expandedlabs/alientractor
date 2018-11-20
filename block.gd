extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var width

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	width = $shape.polygon[1].x
	pass

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if position.x < -width:
		get_parent().remove_child(self)
		return
	
	# Get game speed
	position.x -= get_node("/root/main_scn_root").get("move_speed") 
	pass
