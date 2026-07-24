extends Node2D

@onready var area_spawn: Node2D = $SpawnInimigo


var cartas = {
	
	
	
	
}

var cooldown = 0.5
var dano_bala = 3
var dano_espada = 5

var tempo = 30
var player : CharacterBody2D

func _ready() -> void:
	tempo = 30
	cooldown = 0.5
	dano_bala = 3
	dano_espada = 5

func _physics_process(delta):
	if tempo > 0:
		tempo -= delta

	if tempo <= 0:
		tempo = 0
