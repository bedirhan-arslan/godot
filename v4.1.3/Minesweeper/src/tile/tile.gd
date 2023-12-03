extends Area2D

var type: int
var color: int
var isMouseOn: bool
var isClicked := false
var isFinished := false
var pos: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if type == 1:
		#$Bomb.self_modulate = Color(1, 1, 1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !isFinished:
		if !isClicked:
			var tiles = get_parent().tiles
			if tiles[pos.x][pos.y-1].isClicked and tiles[pos.x][pos.y-1].type != -1:
				$vertical_outline_left.visible = true
			if tiles[pos.x][pos.y+1].isClicked and tiles[pos.x][pos.y+1].type != -1:
				$vertical_outline_right.visible = true
			if tiles[pos.x-1][pos.y].isClicked and tiles[pos.x-1][pos.y].type != -1:
				$horizontal_outline_top.visible = true
			if tiles[pos.x+1][pos.y].isClicked and tiles[pos.x+1][pos.y].type != -1:
				$horizontal_outline_bottom.visible = true
			
			if isMouseOn:			
				if Input.is_action_just_pressed("mouse_1") and $Flag.visible == false:
					isClicked = true
					if type == 0:
						if get_parent().isFirstClick:
							_clear_bombs()
							_check_bombs()
							_change_color()
							get_parent().isFirstClick = false
						_check_bombs()
						_change_color()
						
						get_parent()._check_finish()
						
					else:
						if get_parent().isFirstClick:
							get_parent().isFirstClick = false
							type = 0
							_clear_bombs()
							_check_bombs()
							_change_color()
							return
						
						get_parent()._game_over()
			
				elif Input.is_action_just_pressed("mouse_2"):
					$Flag.visible = !$Flag.visible
					var tw = create_tween()
					tw.tween_property($Flag, "modulate", Color(1, 1, 1, 1), 0.1).from(Color(1, 1, 1, 0))

		else:
			$vertical_outline_left.visible = false
			$vertical_outline_right.visible = false
			$horizontal_outline_bottom.visible = false
			$horizontal_outline_top.visible = false


func _on_mouse_entered():
	isMouseOn = true
	if !isClicked:
		$TileSprite.modulate *= 1.1
		#_see_bombs()

func _on_mouse_exited():
	isMouseOn = false
	if !isClicked:
		$TileSprite.modulate /= 1.1

func _check_bombs():
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
		elif count == 2:
			$Label.modulate = Color(0.2, 0.6, 0.2, 1)
		else:
			$Label.modulate = Color(0.8, 0.2, 0.2, 1)
		
		var tw = create_tween()
		tw.tween_property($Label, "modulate", $Label.modulate, 0.1).from(Color($Label.modulate, 0))

	else:
		for i in range(-1, 2):
			for j in range(-1, 2):
				if type != -1:
					if tiles[pos.x+i][pos.y+j].type == 0 and !tiles[pos.x+i][pos.y+j].isClicked:
						tiles[pos.x+i][pos.y+j].ez()

func ez():
	if $Flag.visible == false:
		isClicked = true
		if type == 0:
			_check_bombs()
			if color == 0:
				$TileSprite.modulate = Color(0.9, 0.76, 0.62, 1)
			else:
				$TileSprite.modulate = Color(0.84, 0.72, 0.6, 1)

func _change_color():
	var tw = create_tween()
	if color == 0:
		#$TileSprite.modulate = Color(0.9, 0.76, 0.62, 1)
		tw.tween_property($TileSprite, "modulate", Color(0.9, 0.76, 0.62, 1), 0.1)
	else:
		#$TileSprite.modulate = Color(0.84, 0.72, 0.6, 1)
		tw.tween_property($TileSprite, "modulate", Color(0.84, 0.72, 0.6, 1), 0.1)

func _clear_bombs():
	var tiles = get_parent().tiles
	var x = pos.x + RandomNumberGenerator.new().randi_range(-1, 1)
	var y = pos.y + RandomNumberGenerator.new().randi_range(-1, 1)
	
	if get_parent().clear_count != 0:
		
		if tiles[x][y].type != -1:
			get_parent().clear_count -= 1
			print("clearing " + str(x) + ' ' + str(y))
			tiles[x][y].isClicked = true
			tiles[x][y].type = 0
			tiles[x][y]._check_bombs()
			tiles[x][y]._change_color()
			tiles[x][y]._clear_bombs()
		
	for i in range(1, 25):
		for j in range(1, 25):
			if tiles[i][j].isClicked:
				tiles[x][y]._check_bombs()
				tiles[x][y]._change_color()

func _see_bombs():
	var tiles = get_parent().tiles
	for i in range(-1, 2):
		for j in range(-1, 2):
			if tiles[pos.x+i][pos.y+j].type == 1:
				tiles[pos.x+i][pos.y+j]._show_bomb()

func _show_bomb():
	var m = modulate
	var tw = create_tween()
	tw.tween_property(self, "modulate", m, 2).from(Color(0, 0, 0, 0))
