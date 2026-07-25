extends Armas

var bala = preload("res://cenas_tscn/bala.tscn")
@onready var saida_bala = get_node("Marker2D")

func atacar():
	$Shot.pitch_scale = randf_range(0.7,1.3)
	$Shot.play()
	var instancia_bala = bala.instantiate()

	get_tree().root.add_child(instancia_bala)

	instancia_bala.global_position = saida_bala.global_position
	instancia_bala.rotation = rotation

	instancia_bala.direcao = Vector2.RIGHT.rotated(rotation)
