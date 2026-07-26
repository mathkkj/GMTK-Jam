extends Node2D

var pai: Node2D

func _ready() -> void:
	$CPUParticles2D.emitting = true
	pai = get_parent()

func _process(delta):
	if is_instance_valid(pai):
		global_position = pai.global_position
	else:
		queue_free()
