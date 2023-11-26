extends Node2D

var type = 'empty'
var time := 0.0
# Called when the node enters the scene tree for the first time.

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time >= 1.0:
		time = 0.0
		#print(type)
