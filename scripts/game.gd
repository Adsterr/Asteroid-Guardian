extends Node2D

var save_path = "user://highScore.save"

@onready var timer = $Spawning/SpawnTimer
@onready var score_timer = $UI/Scores/Score/ScoreTimer
@onready var death_message = $UI/DeathMessage

@onready var asteroid_spawns = $Spawning/AsteroidSpawns

@onready var earth = $Earth

@onready var game_over = $UI/GameOver
@onready var backspace_to_reset = $UI/BackspaceToReset
@onready var scoreLabel = $UI/Scores/Score
@onready var high_score = $UI/Scores/HighScore
@onready var info = $UI/Info

var keys_opened = false
@onready var keys = $UI/KEYS

@onready var main_music = $Sound/MainMusic
@onready var big_explosion = $Sound/Big_Explosion
@onready var hit = $Sound/Hit
@onready var explosion = $Sound/Explosion
@onready var click = $Sound/Click
@onready var game_over_sfx = $Sound/GameOver


@onready var shader = $Deco/Shader

const big_explosion_sfx = preload("res://sound/sfx/big_explosion.wav")
const explosion_sfx = preload("res://sound/sfx/explosion.wav")
const hit_sfx = preload("res://sound/sfx/hitHurt.wav")
const click_sfx = preload("res://sound/sfx/click.wav")
const womp_sfx = preload("res://sound/sfx/womp_womp.mp3")

var score = 0
var highScore = 0
var gameOver = false

func _ready():
	load_score()
	high_score.text = str(highScore)
	info.visible = true
	get_tree().set_deferred("paused", true)

func start_game():
	info.visible = false
	timer.start()
	score_timer.start()

func _on_score_timer_timeout():
	if not gameOver:
		score += 1
		score_timer.start()

func _on_spawn_timer_timeout():
	if not gameOver:
		var scene = load("res://scenes/asteroid.tscn")
		var asteroid = scene.instantiate()

		var spawnChildren = asteroid_spawns.get_children()
		var spawn = spawnChildren[randi() % spawnChildren.size() - 1]

		asteroid.position = spawn.position
		add_child(asteroid)

		var direction = earth.position - asteroid.position

		var force = direction * 1500 * get_physics_process_delta_time()
		asteroid.apply_force(force)

		timer.start()

func _on_player_player_exited_screen(msg):
	gameOver = true
	death_message.text = msg
	game_over_sfx.stream = womp_sfx
	game_over_sfx.play()

func _on_earth_died(msg):
	big_explosion.stream = big_explosion_sfx
	big_explosion.play()
	game_over_sfx.stream = womp_sfx
	game_over_sfx.play()
	death_message.text = msg
	gameOver = true

func _on_player_destroyed_atsteroid():
	explosion.stream = explosion_sfx
	explosion.play()
	if not gameOver:
		score += 100

func _on_earth_hit():
	hit.stream = hit_sfx
	hit.play()

func _on_main_music_finished():
	main_music.play()

func _process(delta):
	if Input.is_action_just_pressed("other_keys"):
		if not keys_opened:
			keys.visible = true
			keys_opened = true
		else:
			keys.visible = false
			keys_opened = false
	elif Input.is_action_just_pressed("toggle_shader"):
		if shader.visible == true:
			shader.visible = false
		else:
			shader.visible = true

	if not get_tree().paused:
		if Input.is_action_just_pressed("reset_game"):
			click.stream = click_sfx
			click.play()
			save_score()
			get_tree().reload_current_scene()

		if not gameOver:
			scoreLabel.text = str(score)
		else:
			main_music.stop()
			game_over.visible = true
			backspace_to_reset.visible = true
			death_message.visible = true
			if score > highScore:
				highScore = score
				high_score.text = str(highScore)
	else:
		if Input.is_action_just_pressed("start_game"):
			get_tree().set_deferred("paused", false)
			start_game()

func save_score():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(highScore)
	print("data saved.")

func load_score():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		highScore = file.get_var(highScore)
		print("data loaded.")
	else:
		print("no data found..")
		highScore = 0

func _notification(req):
	if req == NOTIFICATION_WM_CLOSE_REQUEST:
		save_score()
		get_tree().quit()
