extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _animation():
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(360, 340), 0.5)


func _on_death_hit_finished():
	_animation()
