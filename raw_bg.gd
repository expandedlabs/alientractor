extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var project_width = ProjectSettings.get_setting("display/window/size/width")

var has_neighbor = false
var background_inst = preload("res://raw_bg.tscn")
var texture_width

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	texture_width = texture.get_size().x
	pass
	
func _physics_process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	
	if -(offset.x) > texture_width:
		get_parent().remove_child(self)
		return
	
	# Get game speed
	offset.x -= get_node("/root/main_scn_root").get("move_speed") 
	
	# Find potential location of a new bg object
	var tip_x = offset.x + texture_width
	
	# Check if we need to add a new bg object next to this bg object
	# has_neighbor designates only one bg to spawn
	if tip_x <= project_width and not has_neighbor:
		has_neighbor = true
		var new_bg = background_inst.instance()
		new_bg.offset.x = tip_x
		get_parent().add_child(new_bg)
		
	pass
