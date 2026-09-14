# ใบเลื่อย/ของหมุน
extends Node3D

@export var spin_axis := Vector3.FORWARD
@export var spin_speed := 260.0

func _process(delta: float) -> void:
	rotate(spin_axis.normalized(), deg_to_rad(spin_speed * delta))
