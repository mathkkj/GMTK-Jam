extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	get_tree().paused = false
	Global.transition.emit("out")
	await Global.change
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	Global.transition.emit("out")
	await Global.change
	get_tree().quit()
