extends CharacterBody2D
class_name Inimigos

@onready var alvo = get_parent().get_node("player")
@onready var sprite = get_node("sprite")

@export var vida = 12

@export var velocidade := 150.0
@export var dano := 10

@export var forca_knockback := 350.0
@export var atrito_knockback := 1800.0

var direcao := Vector2.ZERO
var knockback := Vector2.ZERO

var tomando_knockback := false

var pode_dar_dano := true


func _physics_process(delta):
	#knockback
	if tomando_knockback:
		knockback = knockback.move_toward(
			Vector2.ZERO,
			atrito_knockback * delta
		)
		velocity = knockback
		if knockback.length() < 10:
			tomando_knockback = false
	else:
		direcao = (alvo.global_position - global_position).normalized()
		# vira o inimigo na direção que está andando
		if direcao.x != 0:
			sprite.flip_h = direcao.x > 0
		velocity = direcao * velocidade
	move_and_slide()


func receber_dano(dano_recebido, direcao_knockback, forca):

	vida -= dano_recebido
	knockback = direcao_knockback.normalized() * forca
	tomando_knockback = true
	sprite.self_modulate = Color(5, 5, 5)
	await get_tree().create_timer(0.08).timeout
	sprite.self_modulate = Color.WHITE
	empurrar_inimigos_colididos()

	if vida <= 0:
		queue_free()



func _on_hurtbox_body_entered(body):
	if !pode_dar_dano:
		return

	if !body.is_in_group("player"):
		return

	if body.invencivel:
		return

	pode_dar_dano = false
	body.receber_dano(dano,direcao,500)
	
	await get_tree().create_timer(0.3).timeout
	pode_dar_dano = true

func empurrar_inimigos_colididos() -> void:
	#pega os random q ta colidindo
	for i in range(get_slide_collision_count()):
		var col := get_slide_collision(i)
		var outro = col.get_collider()
		#se o random n for nulo, for um inimigo e nao for vc mesmo ele taca o dano
		if outro != null and outro is Inimigos and outro != self:
			var direcao_empurrao = (outro.global_position - global_position).normalized()
			#receba 0 de dano
			outro.receber_dano(0,direcao_empurrao, forca_knockback * 1.2) 
			
