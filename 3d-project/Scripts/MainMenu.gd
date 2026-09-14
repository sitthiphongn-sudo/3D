extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_start_pressed() -> void:
	GameManager.go_to_level(1)

func _on_level2_pressed() -> void:
	GameManager.go_to_level(2)

func _on_quit_pressed() -> void:
	get_tree().quit()
