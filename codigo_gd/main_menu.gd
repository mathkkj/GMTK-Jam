extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.transition.emit("in")
	Musica.menumusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass





func _on_play_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property($Play,"scale",Vector2(2.2,2.2),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)



func _on_play_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property($Play,"scale",Vector2(2,2),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_play_pressed() -> void:
	var tween = create_tween()
	tween.tween_property($Play,"scale",Vector2(2,2),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	Global.transition.emit("out")
	await Global.change
	get_tree().change_scene_to_file("res://node_2d.tscn")
