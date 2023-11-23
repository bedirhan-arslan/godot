extends Node2D

var pipe_speed : float
var time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position.y = randi_range(-200, 250)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""
	time += delta
	
	if time >= 5:
		pipe_speed += 0.2
		print("pipe_speed: " + str(pipe_speed))
		time = 0"""
	
	$PipeArea/Ceiling.global_position = Vector2(300, 0)
	
	pipe_speed = (float(get_parent().score)/15) + 5
	
	if get_parent().get_node("Bird").is_bird_alive:
		global_position.x -= pipe_speed

		

	if global_position.x < -100:
		global_position.x += 1500
		global_position.y = randi_range(-200, 250)


func _on_pipe_area_body_entered(body):
	
	if body.name == "Bird":
		if body.is_bird_alive:
			body.kill_bird()
			get_parent().gameover = true
			body.velocity.y = 0


func _on_pass_body_entered(body):
	if body.name == "Bird":
		get_parent().increase_score()

