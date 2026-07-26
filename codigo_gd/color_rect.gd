extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.transition.connect(transition)
	Global.change.connect(set_true)

func transition(type):
	if type == "in":
		$"../Animation".play("In")
	elif type == "out":
		$"../Animation".play("Out")
	else:
		return
func set_true():
	Global.change_scene = true

func _on_animation_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"Out":
			Global.change.emit()
