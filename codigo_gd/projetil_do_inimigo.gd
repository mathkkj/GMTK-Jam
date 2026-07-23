extends Node2D

var dir := Vector2.ZERO
@export var speed := 500
@export var tempo_vida: float = 3.0
@export var dano = 10

func _ready():
	await get_tree().create_timer(tempo_vida).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += dir * speed * delta

func _on_area_2d_body_entered(body: Node2D):
	# dano no player
	if body.is_in_group("player"):

		if body.invencivel:
			return

		body.receber_dano(dano,dir,600)

		queue_free()
		return



func _on_hurtbox_area_entered(area: Area2D) -> void:
	
	# espada destruindo bala
	if area.is_in_group("espada"):

		if area.get_parent().atacando:
			queue_free()
			return


	# bala destruindo bala
	if area.is_in_group("bala"):
		queue_free()
		area.get_parent().queue_free()
		return
