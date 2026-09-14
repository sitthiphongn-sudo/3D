# ลูกตุ้มหนามแกว่ง
extends Node3D

@export var max_angle := 55.0
@export var speed := 1.6
@export var phase := 0.0

var t := 0.0

func _ready() -> void:
	t = phase

func _process(delta: float) -> void:
	t += delta * speed
	rotation_degrees.z = max_angle * sin(t)
