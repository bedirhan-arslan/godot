extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if get_parent().get_node("Bird").is_bird_alive:
		global_position.x -= get_parent().get_node("Pipe").pipe_speed
	if global_position.x < 10:
		global_position.x += 80
