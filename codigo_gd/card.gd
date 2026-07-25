extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(3,3),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.set_parallel()
	tween.tween_property($Icon,"scale",Vector2(1.2,1.2),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)


func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(2.7,2.7),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.set_parallel()
	tween.tween_property($Icon,"scale",Vector2(1,1),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
