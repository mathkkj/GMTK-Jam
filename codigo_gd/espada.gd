extends Armas

@onready var sprite = get_node("AnimatedSprite2D")
@onready var hitbox = get_node("hitbox")

var atacando := false
var ja_deu_dano := []

@export var dano: int = 6


func atacar():

	if atacando:
		return

	atacando = true
	ja_deu_dano.clear()

	sprite.sprite_frames.set_animation_loop("atacando", false)
	sprite.play("atacando")

	for body in hitbox.get_overlapping_bodies():

		if body.has_method("receber_dano") and body.is_in_group("inimigos") and body not in ja_deu_dano:
			#esse body ja deu dano é pra n dar dano duas vezes no msm inimigo
			ja_deu_dano.append(body)

			var direcao = (body.global_position - global_position).normalized()

			body.receber_dano(dano,direcao,500)

	await sprite.animation_finished

	atacando = false
	sprite.play("normal")

func _on_hitbox_body_entered(body: Node2D):

	if body.has_method("receber_dano") \
	and body.is_in_group("inimigos") \
	and atacando:

		var direcao = (body.global_position - global_position).normalized()

		body.receber_dano(dano,direcao,500)
