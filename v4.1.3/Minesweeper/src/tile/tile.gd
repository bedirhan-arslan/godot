extends Area2D

var type: int
var color: int
var isMouseOn: bool
var isClicked := false
var pos: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if type == 1:
		#$Bomb.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isClicked and isMouseOn:
		if Input.is_action_just_pressed("mouse_1") and $Flag.visible == false:
			isClicked = true
			if type != 1:
				_check_bombs(0)
				if color == 0:
					$TileSprite.modulate = Color(0.9, 0.76, 0.62, 1)
				else:
					$TileSprite.modulate = Color(0.84, 0.72, 0.6, 1)
			else:
				$Bomb.visible = true
				print("Game Over")
			
			get_parent()._check_finish()
			
		elif Input.is_action_just_pressed("mouse_2"):
			$Flag.visible = !$Flag.visible


func _on_mouse_entered():
	isMouseOn = true
	if !isClicked:
		$TileSprite.modulate *= 1.1

func _on_mouse_exited():
	isMouseOn = false
	if !isClicked:
		$TileSprite.modulate /= 1.1

func _check_bombs(check: int):
	var tiles = get_parent().tiles
	var count = 0
	for i in range(-1, 2):
		for j in range(-1, 2):
			if tiles[pos.x+i][pos.y+j].type == 1:
				count += 1
	
	if count != 0:
		$Label.visible = true
		$Label.text = str(count)
		if count == 1:
			$Label.modulate = Color(0.4, 0.4, 1, 1)
	else:
		if check != 2:
			for i in range(-1, 2):
				for j in range(-1, 2):
					tiles[pos.x+i][pos.y+j].ez(check)

func ez(check: int):
	if Input.is_action_just_pressed("mouse_1") and $Flag.visible == false:
		isClicked = true
		if type == 0:
			_check_bombs(check+1)
			if color == 0:
				$TileSprite.modulate = Color(0.9, 0.76, 0.62, 1)
			else:
				$TileSprite.modulate = Color(0.84, 0.72, 0.6, 1)
		else:
			$Bomb.visible = true
			print("Game Over")
		
	elif Input.is_action_just_pressed("mouse_2"):
		$Flag.visible = !$Flag.visible
