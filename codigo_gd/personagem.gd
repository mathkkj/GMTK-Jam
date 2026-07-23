extends CharacterBody2D

@export var velocidade: float = 350.0
@export var aceleracao: float = 2750.0
@export var atrito: float = 1500.0
@export var dash_vel: float = 1300.0

@export var DASH_TIMER: float = 0.10
@export var tempo_recarregamento_dash: float = 1.0

@export var vida = 10
@onready var colisao = get_node("CollisionShape2D")

var invencivel := false
var dashing := false

@onready var sprite = get_node("sprite")

@onready var hitbox = get_node("hitbox")

var ultima_direcao_y := 1

@onready var espada_cena = preload("res://cenas_tscn/espada.tscn")
@onready var revolver_cena = preload("res://cenas_tscn/arma.tscn")

var pode_dash: bool = true
var tempo_dash: float = 0.0
var recarregar_tempo_dash: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO

@export var armas: Array[PackedScene] = [
	espada_cena,
	revolver_cena,
]

var indice_arma := 0
var arma_atual: Node2D


func _ready():
	atualizar_arma()

func atualizar_arma():

	if armas.is_empty():
		return

	if armas[indice_arma] == null:
		return


	if arma_atual:
		arma_atual.queue_free()


	arma_atual = armas[indice_arma].instantiate()
	print(arma_atual)
	add_child(arma_atual)

func mudar_arma(valor):
	if armas.is_empty():
		return

	indice_arma += valor

	# faz voltar para o começo ou fim as armas
	if indice_arma >= armas.size():
		indice_arma = 0
	elif indice_arma < 0:
		indice_arma = armas.size() - 1

	atualizar_arma()


func atualizar_animacao():

	var direcao_mira = get_global_mouse_position() - global_position

	var tipo_animacao = "idle"

	if velocity.length() > 0:
		tipo_animacao = "andar"


	# MOUSE PARA CIMA
	if direcao_mira.y < 0:
		sprite.play(tipo_animacao + "_cima")

	# MOUSE PARA BAIXO
	else:
		sprite.play(tipo_animacao + "_baixo")
		
func _physics_process(delta: float) -> void:
	
	
	atualizar_animacao()
	#trocar arma
	if Input.is_action_just_pressed("trocar_arma_cima"):
		mudar_arma(1)

	if Input.is_action_just_pressed("trocar_arma_baixo"):
		mudar_arma(-1)

	
	
	var direcao := Input.get_vector("esquerda", "direita", "cima", "baixo")

	if direcao != Vector2.ZERO:
		var velocidade_alvo = direcao.normalized() * velocidade
		velocity = velocity.move_toward(velocidade_alvo, aceleracao * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, atrito * delta)

	_mecanica_dash(delta)
	move_and_slide()
func _mecanica_dash(delta):

	# INICIAR DASH
	if Input.is_action_just_pressed("dash") and pode_dash and !dashing:

		dashing = true
		pode_dash = false
		invencivel = true

		tempo_dash = DASH_TIMER
		

		# tira colisão durante o dash
		hitbox.set_deferred("monitoring", false)
		hitbox.set_deferred("monitorable", false)
		set_collision_mask_value(1, false)
		set_collision_layer_value(1, false)

		dash_dir = Input.get_vector(
			"esquerda",
			"direita",
			"cima",
			"baixo"
		)


		dash_dir = dash_dir.normalized()


	# DURANTE O DASH
	if dashing:

		velocity = dash_dir * 800

		tempo_dash -= delta
		#cabo o dash
		if tempo_dash <= 0:

			dashing = false
			invencivel = false
			# volta com a colisao dps do dash
			hitbox.set_deferred("monitoring", true)
			hitbox.set_deferred("monitorable", true)
			set_collision_mask_value(1, true)
			set_collision_layer_value(1, true)


	# RECARGA DO DASH
	if !pode_dash:
		recarregar_tempo_dash -= delta

		if recarregar_tempo_dash <= 0:
			pode_dash = true

func receber_dano(dano, direcao_knockback, forca_knockback):

	if invencivel:
		return

	invencivel = true

	Global.tempo -= dano
	velocity = direcao_knockback * forca_knockback

	for i in range(6):
		sprite.modulate.a = 0.3
		await get_tree().create_timer(0.08).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.08).timeout

	invencivel = false
	
	
	
