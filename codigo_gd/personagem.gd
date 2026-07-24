extends CharacterBody2D
#movimentacao
@export var velocidade: float = 350.0
@export var aceleracao: float = 2750.0
@export var atrito: float = 1500.0
@export var dash_vel: float = 600.0
@export var atrito_dash := 4500.0


@export var vida = 10
@onready var colisao = get_node("CollisionShape2D")


@onready var sprite = get_node("sprite")
@onready var hitbox = get_node("hitbox")


#dash
var pode_dash: bool = true
var tempo_dash: float = 0.0
var recarregar_tempo_dash: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
var invencivel := false
@export var DASH_TIMER: float = 0.3
@export var tempo_recarregamento_dash: float = 1.0
#armas
@export var armas: Array[PackedScene] = [espada_cena, revolver_cena]
var indice_arma := 0
var arma_atual: Node2D
@onready var espada_cena = preload("res://cenas_tscn/espada.tscn")
@onready var revolver_cena = preload("res://cenas_tscn/arma.tscn")

#estado
enum EstadoJogador { Normal, Dashing }
var estado_atual: EstadoJogador = EstadoJogador.Normal

func _ready():
	Global.player = self
	atualizar_arma()

func atualizar_arma():
	if armas.is_empty():
		return
	if armas[indice_arma] == null:
		return
	#deletar a arma atual para dps colocar a nova
	if arma_atual:
		arma_atual.queue_free()
	arma_atual = armas[indice_arma].instantiate()
	add_child(arma_atual)

func mudar_arma(valor):
	if armas.is_empty():
		return
	indice_arma += valor
	
	#resetar o valor se nao tiver mais nada
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
	if direcao_mira.y < 0:
		sprite.play(tipo_animacao + "_cima")
	else:
		sprite.play(tipo_animacao + "_baixo")


#var ultima_direcao := "baixo"
#func atualizar_animacao():
	#var tipo_animacao = "idle"
#
	#if velocity.length() > 0:
		#tipo_animacao = "andar"
#
		#if velocity.y < 0:
			#ultima_direcao = "cima"
		#elif velocity.y > 0:
			#ultima_direcao = "baixo"
#
	#sprite.play(tipo_animacao + "_" + ultima_direcao)

func _physics_process(delta: float) -> void:
	
	atualizar_animacao()
	# trocar de arma
	if Input.is_action_just_pressed("trocar_arma_cima"):
		mudar_arma(1)
	if Input.is_action_just_pressed("trocar_arma_baixo"):
		mudar_arma(-1)

	var direcao = Input.get_vector("esquerda", "direita", "cima", "baixo")
	#logica dos estados
	match estado_atual:
		EstadoJogador.Normal:
			# movimentação
			if direcao != Vector2.ZERO:
				#andar
				var velocidade_alvo = direcao.normalized() * velocidade
				velocity = velocity.move_toward(velocidade_alvo, aceleracao * delta)
			else:
				#ficar parado
				velocity = velocity.move_toward(Vector2.ZERO, atrito * delta)
			
			
			# iniciar dash se puder
			if Input.is_action_just_pressed("dash") and pode_dash:
				estado_atual = EstadoJogador.Dashing
				invencivel = true
				tempo_dash = DASH_TIMER
				pode_dash = false
				# desativar a hitbox durante dash
				hitbox.set_deferred("monitoring", false)
				hitbox.set_deferred("monitorable", false)
				set_collision_mask_value(1, false)
				set_collision_layer_value(1, false)
				dash_dir = direcao.normalized()
		
		EstadoJogador.Dashing:
			# dash mecanicas
			velocity = dash_dir.normalized() * dash_vel
			tempo_dash -= delta
			if tempo_dash <= 0:
				estado_atual = EstadoJogador.Normal
				invencivel = false
				# voltar com a hitbox
				hitbox.set_deferred("monitoring", true)
				hitbox.set_deferred("monitorable", true)
				set_collision_mask_value(1, true)
				set_collision_layer_value(1, true)
				

	# recarga do dash
	if not pode_dash:
		
		recarregar_tempo_dash -= delta
		if recarregar_tempo_dash <= 0:
			pode_dash = true

	move_and_slide()

func receber_dano(dano, direcao_knockback, forca_knockback):
	if invencivel:
		return
	invencivel = true
	Global.tempo -= dano
	#knockback
	velocity = direcao_knockback * forca_knockback
	#efeito pra ficar piscando
	for i in range(6):
		sprite.modulate.a = 0.3
		await get_tree().create_timer(0.08).timeout
		sprite.modulate.a = 1.0
		await get_tree().create_timer(0.08).timeout
	invencivel = false
