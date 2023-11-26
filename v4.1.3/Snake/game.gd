extends Node2D

var time := 0.0
var prevTime := 0.0
var foodSpawnTime := 0.0
var tiles = []
var firstPos := Vector2i(-16, -16)
var snakePos = [Vector2i(7, 7), Vector2i(8, 7), Vector2i(9, 7), Vector2i(9, 6)]
var direction = Vector2i(-1, 0)
var groundColor = Color(0, 0.7, 0, 1)
var rng = RandomNumberGenerator.new()
var gameSpeed = 0.5
var score = 0
var isGameOver = false

@onready var tilePath = preload("res://src/tile/tile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(16):
		tiles.append([])
		for j in range(16):
			#print('i: ' + str(i) + ' j: ' + str(j))
			var newTile = tilePath.instantiate()
			newTile.global_position = Vector2i(firstPos.x + (32 * (j+1)), firstPos.y + (32 * (i+1)))
			if i == 0 or i == 15 or j == 0 or j == 15:
				newTile.type = 'wall'
				newTile.modulate = Color(0.1, 0.1, 0.1, 1)
			else:
				newTile.type = 'empty'
				newTile.modulate = groundColor
			tiles[i].append(newTile)
			add_child(newTile)
	
	spawnFood()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	takeInput()
	if !isGameOver:
		if time-prevTime >= gameSpeed:
			prevTime = time
			processSnake()
			$Control/Control2/Label3.text = str(score)
			if time-foodSpawnTime >= 2.5:
				foodSpawnTime = time
				if rng.randf() >= 0.5:
					spawnFood()

func processSnake():
	var next
	var lastPos
	for i in range(len(snakePos)-1, 0, -1):
		next = snakePos[i-1]
		if i == len(snakePos)-1:
			tiles[snakePos[i].x][snakePos[i].y].modulate = groundColor
			tiles[snakePos[i].x][snakePos[i].y].type = 'empty'
			lastPos = snakePos[i]
			snakePos[i] = next
		else:
			tiles[snakePos[i].x][snakePos[i].y].modulate = Color(0.5, 0, 0, 1)
			tiles[snakePos[i].x][snakePos[i].y].type = 'snake'
			snakePos[i] = next

	tiles[snakePos[0].x][snakePos[0].y].modulate = Color(0.5, 0, 0, 1)
	snakePos[0] += direction
	tiles[snakePos[0].x][snakePos[0].y].modulate = Color(1, 0, 0, 1)
	
	if tiles[snakePos[0].x][snakePos[0].y].type == 'food':
		tiles[snakePos[0].x][snakePos[0].y].type = 'empty'
		snakePos.append(lastPos)
		tiles[lastPos.x][lastPos.y].modulate = Color(0.5, 0, 0, 1)
		gameSpeed -= 0.01
		score += 1
	
	if tiles[snakePos[0].x][snakePos[0].y].type == 'snake' or tiles[snakePos[0].x][snakePos[0].y].type == 'wall':
		gameOver()


func takeInput():
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_left") and direction != Vector2i(0, 1):
		direction = Vector2i(0, -1)
	elif Input.is_action_just_pressed("ui_right") and direction != Vector2i(0, -1):
		direction = Vector2i(0, 1)
	elif Input.is_action_just_pressed("ui_up") and direction != Vector2i(1, 0):
		direction = Vector2i(-1, 0)
	elif Input.is_action_just_pressed("ui_down") and direction != Vector2i(-1, 0):
		direction = Vector2i(1, 0)


func spawnFood():
	var x = rng.randi_range(1, 14)
	var y = rng.randi_range(1, 14)
	
	tiles[x][y].type = 'food'
	tiles[x][y].modulate = Color(0.8, 0.5, 0, 1)
	
	print("food spawned at: " + str(x) + ' ' + str(y))

func createTile(i: int, j: int):
	var newTile = tilePath.instantiate()
	add_child(newTile)


func gameOver():
	isGameOver = true
	print($Control.global_position)
	var tw = create_tween()
	tw.tween_property($Control/Label, "global_position", Vector2(130, 150), 0.5)
	
	var tw2 = create_tween()
	tw2.tween_property($Control/Control2, "global_position", Vector2(130, 250), 0.5)
	
	var tw3 = create_tween()
	tw3.tween_property($Control/Control2, "scale", 1, 0.5)
	print($Control.global_position)
