extends Node2D

var difficulty = "easy"
var tilePath = preload("res://src/tile/tile.tscn")
var tiles = []
var time := 0.0
var prevTime := 0.0
var isFinished := false
var isFirstClick = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_window().size = Vector2i(24*32, 25*32)
	var tileColor = true
	for i in range(26):
		tiles.append([])
		tileColor = !tileColor
		for j in range(26):
			var tile = tilePath.instantiate()
			if i == 0 or i == 25:
				tile.type = -1
			elif j == 0 or j == 25:
				tile.type = -1
			else:
				tile.type = 0 if RandomNumberGenerator.new().randf() > 0.2 else 1
			
			if tile.type == -1:
				tile.get_child(0).modulate = Color(0.29, 0.46, 0.17, 1)
				tile.isClicked = true
			else:
				tile.get_child(0).modulate = Color(0.66, 0.84, 0.32, 1) if tileColor else Color(0.63, 0.81, 0.28, 1)
			tile.global_position = Vector2i(-16 + (32 * j), 16 + (32 * i))
			tile.color = 0 if tileColor else 1
			tileColor = !tileColor
			tile.pos = Vector2i(i, j)
			tiles[i].append(tile)
			add_child(tile)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_time(delta)
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

func _time(delta):
	if !isFinished:
		time += delta
		#$Label.text = "Time: " + str(snappedf(time, 0.01))
		if time - prevTime >= 1.0:
			prevTime = time
			$Label.text = "Time: " + str(int(time))

func _check_finish():
	isFinished = true
	for i in range(1, 25):
		for j in range(1, 25):
			var t = tiles[i][j]
			if t.type == 0 and !t.isClicked:
				isFinished = false
	
	if isFinished:
		print("Won")
		var tw = create_tween()
		tw.tween_property($Win, "global_position", Vector2($Win.global_position.x, $Win.global_position.y + 450), 0.5)
		_show_bombs()

func _game_over():
	print("Game Over")
	isFinished = true
	var tw = create_tween()
	tw.tween_property($Control, "global_position", Vector2($Control.global_position.x, $Control.global_position.y + 450), 0.5)
	_show_bombs()

func _show_bombs():
	for i in tiles:
		for j in i:
			j.isClicked = true
			if j.type == 1:
				var tw = create_tween()
				tw.tween_property(j.get_child(3), "self_modulate", Color(1, 1, 1, 1), RandomNumberGenerator.new().randf())
