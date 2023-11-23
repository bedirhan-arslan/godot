extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_parent().name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_pause") and !get_parent().gameover:
		get_parent().get_tree().paused = !(get_parent().get_tree().paused)
		print("pause")
		get_node("pause_text").visible = !get_node("pause_text").visible

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
		get_parent().get_tree().paused = false
		get_node("pause_text").visible = false
	
	
