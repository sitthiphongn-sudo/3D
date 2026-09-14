# กล้องแบบ Gimbal จาก 3D Platformer Starter Kit (ปรับ clamp มุมก้ม/เงย)
extends Node3D

@export var mouse_sensitivity := 0.2

func _ready() -> void:
	top_level = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clampf(rotation_degrees.x, -55, 10)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
	if event is InputEventMouseButton and event.pressed:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
