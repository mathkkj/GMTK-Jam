extends CanvasLayer
@onready var label_tempo = get_node("tempo")
@onready var label_arma = get_node("arma")

func _physics_process(delta: float) -> void:
	label_tempo.text = str(int(Global.tempo))
	label_arma.text = get_parent().get_node("player").arma_atual.name
