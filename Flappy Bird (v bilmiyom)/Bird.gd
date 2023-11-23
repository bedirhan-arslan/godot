extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -700.0
const jump_vel = 3
var jump_time = 0.15
@export var gravity_scale : float = 0
@onready var animated_sprite = $AnimatedSprite2D
var is_bird_alive : bool = false
var dead_first_time : bool = true
var game_start : bool = false

var time = 0
var Ongoing_Time = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
 
func kill_bird():
	is_bird_alive = false
	$"../DeathHit".play()

func set_gravity():
	gravity_scale = 0
	velocity.y = 0

func _ready():
	animated_sprite.play("default")
	get_parent().get_node("Score").visible = false

func _physics_process(delta):
	
	if !game_start:
		if Input.is_action_just_pressed("ui_accept"):
			get_parent().get_node("Score").visible = true
			get_parent().get_node("Message").visible = false
			animated_sprite.play("default")
			game_start = true
			is_bird_alive = true
			gravity_scale = 2.5

	if !is_bird_alive:
		animated_sprite.stop()
	
	# Add the gravity.
	velocity.y += gravity * delta * gravity_scale

	if is_bird_alive:
		# Handle Jump.
		if Input.is_action_just_pressed("ui_accept"): 
			#animated_sprite.play("default")
			velocity.y = JUMP_VELOCITY
			jump_time = 0

		if jump_time < 0.4:
			global_position.y -= jump_vel

	if velocity.y > 0 and rotation < 1: #rotate right
		rotation += 0.08
	elif velocity.y < 0 and rotation > -0.45 and is_bird_alive: #rotate left
		rotation -= 0.25
		if rotation < -0.45:
			rotation = -0.45
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	"""
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	"""
	time += delta
	jump_time += delta

	if time >= 1:
		Ongoing_Time += 1
		time = 0
		#print(rotation)

	move_and_slide()


func _on_death_hit_finished():
	$"../DeathFall".play()
