extends Node2D

@onready var area_spawn: Node2D = $SpawnInimigo

var cooldown : float
var dano_bala : int
var dano_espada : int
var resistencia : int
var dashcooldown : float

var tempo = 30
var player : CharacterBody2D

var musica = "Menu"

var change_scene = false
signal transition(type:String)
signal change()




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
