extends Node2D

@onready var area_spawn: Node2D = $SpawnInimigo

var cooldown = 0.5
var dano_bala = 3
var dano_espada = 5
var resistencia = 1
var dashcooldown = 3.0

var tempo = 30
var player : CharacterBody2D


var cartas = {
	"Sharpness":{
		"efeito": func(): aplicar_efeito_card("DanoEspada")
		},
	"Agility":{
		"efeito": func(): aplicar_efeito_card("Dash")
		},
	"Drilling":{
		"efeito": func(): aplicar_efeito_card("DanoBala")
		},
	"Resistance":{
		"efeito": func(): aplicar_efeito_card("Resistencia")
		},
	"Patience":{
		"efeito": func(): aplicar_efeito_card("MaisTempo")
		}
		
}


func _ready() -> void:
	pass

func _physics_process(delta):
	if tempo > 0:
		tempo -= delta

	if tempo <= 0:
		tempo = 0

func aplicar_efeito_card(efeito: String):
	match efeito:
		"DanoEspada":
			dano_espada += 2
		"Resistencia":
			resistencia += 0.2
		"Dash":
			dashcooldown /=2
		"DanoBala":
			dano_bala +=1
		"MaisTempo":
			tempo += 30
