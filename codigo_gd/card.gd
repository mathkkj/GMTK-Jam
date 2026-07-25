extends AnimatedSprite2D


var carta = Global.cartas.keys().pick_random()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(carta)
	match carta:
		"Sharpness":
			$".".frame = 0
		"Agility":
			$".".frame = 1
		"Drilling":
			$".".frame = 2
		"Resistance":
			$".".frame = 3
		"Patience":
			$".".frame = 4


func _on_card_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(3,3),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_card_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(2.7,2.7),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_card_pressed() -> void:
	match carta:
		"Sharpness":
			Global.cartas["Sharpness"]["efeito"].call()

		"Agility":
			Global.cartas["Agility"]["efeito"].call()

		"Drilling":
			Global.cartas["Drilling"]["efeito"].call()

		"Resistance":
			Global.cartas["Resistance"]["efeito"].call()

		"Patience":
			Global.cartas["Patience"]["efeito"].call()
