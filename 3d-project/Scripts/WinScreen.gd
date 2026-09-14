extends Control

@onready var stats: Label = $Center/VBox/Stats

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	stats.text = "You escaped the temple ruins!\nTimes fallen or trapped: %d" % GameManager.deaths

func _on_menu_pressed() -> void:
	GameManager.go_to_menu()
