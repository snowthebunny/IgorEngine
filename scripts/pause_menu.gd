extends Control

func _ready():
	get_tree().paused = true

func _on_resume_pressed():
	get_tree().paused = false
	queue_free()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_exit_pressed():
	get_tree().quit(0)
