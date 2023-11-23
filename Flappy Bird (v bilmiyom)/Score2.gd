extends Node2D

@onready var birler = $Score_Birler
@onready var onlar = $Score_Onlar
var s
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""
	time += delta
	if time >= 1:
		print(birler.global_position)
		print(onlar.global_position)
		time = 0
	"""
	var grandparent = get_parent().get_parent()
	s = grandparent.score
	if s < 10:
		onlar.visible = false
	else:
		onlar.visible = true
	birler.set_frame(s % 10)
	onlar.set_frame(int(s / 10))
