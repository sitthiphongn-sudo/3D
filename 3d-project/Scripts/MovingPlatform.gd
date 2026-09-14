# แพลตฟอร์มเลื่อน (ใช้ AnimatableBody3D เพื่อพาผู้เล่นไปด้วย)
extends AnimatableBody3D

@export var travel := Vector3(0, 0, 6)
@export var speed := 1.0
@export var phase := 0.0

var origin := Vector3.ZERO
var t := 0.0

func _ready() -> void:
	origin = position
	t = phase

func _physics_process(delta: float) -> void:
	t += delta * speed
	position = origin + travel * (0.5 - 0.5 * cos(t))
