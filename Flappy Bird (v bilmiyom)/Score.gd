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

	s = get_parent().score
	if s >= 10:
		onlar.global_position.x = 346
		birler.global_position.x = 412
	birler.set_frame(s % 10)
	onlar.set_frame(int(s / 10))
