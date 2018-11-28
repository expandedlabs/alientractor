extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var width
signal block_disappear

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	width = $Sprite.texture.get_size().x
	pass

func _restart():
	get_parent().remove_child(self)
	pass

func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if position.x < -width:
		get_parent().remove_child(self)
		emit_signal("block_disappear")
		return
	
	# Get game speed
	position.x -= get_node("/root/main_scn_root").move_speed
	pass
