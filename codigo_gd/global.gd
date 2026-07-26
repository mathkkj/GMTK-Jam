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
		"efeito": func(): aplicar_efeito_card("DanoEspada"),
		"descricao": "Increases sword damage by +2."
	},
	"Agility":{
		"efeito": func(): aplicar_efeito_card("Dash"),
		"descricao": "Reduces dash cooldown by half."
	},
	"Drilling":{
		"efeito": func(): aplicar_efeito_card("DanoBala"),
		"descricao": "Increases bullet damage by +1."
	},
	"Resistance":{
		"efeito": func(): aplicar_efeito_card("Resistencia"),
		"descricao": "Increases your resistance against damage."
	},
	"Patience":{
		"efeito": func(): aplicar_efeito_card("MaisTempo"),
		"descricao": "Adds 30 more seconds to the match timer."
	}
}


func _physics_process(delta):
	if tempo > 0:
		tempo -= delta

	if tempo <= 0:
		tempo = 0

func aplicar_efeito_card(efeito: String):
	Musica.sfxcard.play()
	match efeito:
		"DanoEspada":
			print("aumentei 2 na espada")

			dano_espada += 2
		"Resistencia":
			print("aumentei 0.2 na resistencia")

			resistencia += 0.2
		"Dash":
			print("diminui na metade o cooldown do dash")

			dashcooldown /=2
		"DanoBala":
			dano_bala +=1
			print("adicionei +1 no dano da bala")

		"MaisTempo":
			tempo += 30
			print("adicionei tempo")
