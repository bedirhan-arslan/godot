extends Node2D

var score : int = 0
var highscore : int
var current_time : float = 0
var sound_finished : bool = false
var gameover : bool = false
@onready var highscore_file = "res://highscore.md"

func increase_score():
	score += 1
	$ScoreSound.play()

func load_file():
	var file = FileAccess.open(highscore_file, FileAccess.READ)
	highscore = int(file.get_as_text())

func store_file():
	var file = FileAccess.open(highscore_file, FileAccess.WRITE)
	file.store_string(str(highscore))

# Called when the node enters the scene tree for the first time.
func _ready():
	load_file()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
	
	if !get_node("Bird").is_bird_alive:
		if Input.is_action_just_pressed("ui_accept") and sound_finished:
			get_tree().reload_current_scene()

	if score > highscore:
		highscore = score
		store_file()
	
	#$Label.text = str(highscore)
	
func _on_ground_body_entered(body):
	if body.name == "Bird":
		if body.is_bird_alive:
			body.kill_bird()
			gameover = true
		body.set_gravity()


func _on_button_pressed():
	get_tree().paused = false

func _on_death_fall_finished():
	sound_finished = true
