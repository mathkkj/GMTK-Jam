extends Control

func _ready() -> void:
	Global.transition.emit("in")
	Musica.menumusic.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		Global.transition.emit("out")
		await Global.change
		get_tree().quit()
