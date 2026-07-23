extends Node2D
class_name Armas

@export var tempo_cooldown: float = 0.2
@export var distancia_arma: float = 25.0

@onready var player = get_parent()

var pode_atacar := true
var cooldown_atual := 0.0


func _physics_process(delta: float) -> void:

	var direcao_mouse = get_global_mouse_position() - player.global_position


	# orbitar ao redor do player
	if direcao_mouse != Vector2.ZERO:
		global_position = player.global_position + direcao_mouse.normalized() * distancia_arma


	look_at(get_global_mouse_position())


	# flip
	if direcao_mouse.x < 0:
		scale.y = -1
	else:
		scale.y = 1


	# z index
	if direcao_mouse.y < 0:
		z_index = -1
	else:
		z_index = 1


	# cooldown
	if !pode_atacar:

		cooldown_atual -= delta

		if cooldown_atual <= 0:
			pode_atacar = true


	if Input.is_action_pressed("atacar") and pode_atacar:

		atacar()

		pode_atacar = false
		cooldown_atual = tempo_cooldown



func atacar():
	pass
