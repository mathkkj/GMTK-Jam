extends Node2D

@onready var area_spawn: Node2D = $SpawnInimigo

var tempo = 60
var player : CharacterBody2D
func _physics_process(delta):
	if tempo > 0:
		tempo -= delta

	if tempo <= 0:
		tempo = 0
