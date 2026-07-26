extends AnimatedSprite2D

signal carta_escolhida
var tween_desc: Tween
@onready var desc = get_node("desc")

var carta = Global.cartas.keys().pick_random()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	print(carta)
	desc.text = Global.cartas[carta]["descricao"]

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
	mostrar_descricao()
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(3,3),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_card_mouse_exited() -> void:
	esconder_descricao()
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


	emit_signal("carta_escolhida")
	
func mostrar_descricao() -> void:
	if tween_desc:
		tween_desc.kill()

	desc.visible = true
	desc.modulate.a = 0.0

	tween_desc = create_tween()
	tween_desc.tween_property(desc, "modulate:a", 1.0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func esconder_descricao() -> void:
	if tween_desc:
		tween_desc.kill()

	tween_desc = create_tween()
	tween_desc.tween_property(desc, "modulate:a", 0.0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

	await tween_desc.finished
	desc.visible = false

func _process(delta: float) -> void:
	if desc.visible:
		#var destino = get_global_mouse_position() + Vector2(20, 20)
		desc.global_position = desc.global_position.lerp(get_global_mouse_position(), delta * 15)
