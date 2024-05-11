extends RigidBody2D

signal destroyedAtsteroid
signal playerExitedScreen(message)

@onready var screenSize = get_viewport_rect().size # camera size

@export var speed = 1500 # pixels per second \/
@export var acceleration = 10
@export var rotate = 0.1

var speedR = speed * -1

func _physics_process(delta):
	handleInput(delta)
	rotatePlayer(rotate, delta)

func handleInput(delta):
	if Input.is_action_pressed("move_right"):
		apply_force(Vector2(speed * acceleration * delta, 0))
	elif Input.is_action_pressed("move_left"):
		apply_force(Vector2(speedR * acceleration * delta, 0))
	elif Input.is_action_pressed("move_up"):
		apply_force(Vector2(0, speedR * acceleration * delta))
	elif Input.is_action_pressed("move_down"):
		apply_force(Vector2(0, speed * acceleration * delta))

func rotatePlayer(rotate, delta):
	rotation += 0.1 * delta

func _on_body_entered(body):
	destroyedAtsteroid.emit()

func _on_visible_screen_exited():
	if linear_velocity.length() > 600:
		playerExitedScreen.emit("broke the speed of light and died🙀")
	else:
		playerExitedScreen.emit("flew out of bounds💀")
