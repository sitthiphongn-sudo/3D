extends Node

# ---------------------------------------------------------------- #
#  GameManager (Autoload)
#  ดูแลคะแนน จำนวนไอเทมในด่าน และการเปลี่ยนด่าน
# ---------------------------------------------------------------- #

signal items_changed(collected: int, total: int)

var items_collected: int = 0
var items_total: int = 0
var deaths: int = 0
var current_level_name: String = ""

const LEVELS := {
	1: "res://Scenes/Level1.tscn",
	2: "res://Scenes/Level2.tscn",
}

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("mouse_visible"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("restart") and current_level_name != "":
		get_tree().reload_current_scene()

# เรียกจากแต่ละด่านตอน _ready()
func register_level(level_name: String, total: int) -> void:
	current_level_name = level_name
	items_total = total
	items_collected = 0
	deaths = 0
	items_changed.emit(items_collected, items_total)

func add_item() -> void:
	items_collected += 1
	items_changed.emit(items_collected, items_total)

func all_items_collected() -> bool:
	return items_total > 0 and items_collected >= items_total

func add_death() -> void:
	deaths += 1

func go_to_level(index: int) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if LEVELS.has(index):
		get_tree().change_scene_to_file(LEVELS[index])
	else:
		get_tree().change_scene_to_file("res://Scenes/WinScreen.tscn")

func go_to_menu() -> void:
	current_level_name = ""
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
