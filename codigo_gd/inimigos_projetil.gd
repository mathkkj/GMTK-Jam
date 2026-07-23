extends Inimigos
@onready var bala_cena = preload("res://cenas_tscn/projetil_do_inimigo.tscn")

func _on_timer_timeout() -> void:
	atirar()
	
func atirar():
	var bala = bala_cena.instantiate()
	bala.position = position
	bala.dir = (alvo.global_position - global_position).normalized()
	get_tree().current_scene.add_child(bala)
