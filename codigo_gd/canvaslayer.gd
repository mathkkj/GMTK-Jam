extends CanvasLayer

@onready var label_tempo = get_node("tempo")
@onready var label_arma = get_node("HBoxContainer2/arma")
@onready var icone = get_node("HBoxContainer2/TextureRect")

var armas = {
	"arma": {
		"nome": "Gun",
		"icone": preload("res://sprites/Gun.png")
	},
	"espada": {
		"nome": "Sword",
		"icone": preload("res://sprites/Sword-Sheet (1).png")
	}
}


func _physics_process(delta: float) -> void:
	label_tempo.text = str(int(Global.tempo))

	var arma_atual = get_parent().get_node("player").arma_atual.name

	atualizar_arma(arma_atual)


func atualizar_arma(nome_arma: String) -> void:
	if armas.has(nome_arma):
		label_arma.text = armas[nome_arma]["nome"]
		icone.texture = armas[nome_arma]["icone"]
	else:
		label_arma.text = nome_arma
		icone.texture = null
