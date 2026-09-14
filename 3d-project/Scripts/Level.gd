# สคริปต์ประจำฉาก — นับไอเทมทั้งหมดในด่านแล้วลงทะเบียนกับ GameManager
extends Node3D

@export var level_title := "ด่าน"

func _ready() -> void:
	var total := get_tree().get_nodes_in_group("Collectible").size()
	GameManager.register_level(level_title, total)
