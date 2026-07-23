extends Node2D

@export var velocidade: float = 800.0
@export var dano: int = 6
@export var tempo_vida: float = 2.0

var direcao: Vector2 = Vector2.ZERO


func _ready():
	await get_tree().create_timer(tempo_vida).timeout
	queue_free()


func _physics_process(delta: float) -> void:
	
	position += direcao * velocidade * delta



func _on_area_2d_body_entered(body):

	if body.has_method("receber_dano") and body.is_in_group("inimigos"):
		body.receber_dano(dano, direcao, 150)
		queue_free()
	
