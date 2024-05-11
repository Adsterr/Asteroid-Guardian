extends Area2D

signal died(msg)
signal hit

@onready var text_label = $Label
@onready var debounceTimer = $Debounce

var debounce = false

var health = 100

func _on_body_entered(body):
	if not debounce:
		hit.emit()
		var asteroidSprite = body.get_node("AnimatedSprite2D")
		asteroidSprite.play("explode")

		var rng = RandomNumberGenerator.new()
		rng.randomize()

		var num = rng.randi_range(12, 18)
		health -= num

		var death_msgs = ["the earth died :(", "end of the word, your fault", "bruh", "so bad", "are you afk", "you are so, bad..", "you're worse than hitler", "skill issue fr"]

		var rng2 = RandomNumberGenerator.new()
		rng2.randomize()
		var num2 = rng2.randi_range(0, 6)

		if health <= 0:
			died.emit(death_msgs[num2])

		debounce = true
		debounceTimer.start()

func _on_debounce_timeout():
	debounce = false


func _process(delta):
	text_label.text = str(health) + "%"

	if health == 100:
		text_label.visible = false
	else:
		text_label.visible = true

	if health <= 100 and health > 75:
		text_label.add_theme_color_override("font_color", Color.GREEN)
	elif health <= 75 and health > 50:
		text_label.add_theme_color_override("font_color", Color.ORANGE)
	elif health <= 50 and health > 25:
		text_label.add_theme_color_override("font_color", Color.YELLOW)
	elif health <= 25 and health > 0:
		text_label.add_theme_color_override("font_color", Color.RED)

	if health <= 0:
		text_label.text = "0%"
