# จุดเช็คพอยต์ระหว่างด่าน
extends Area3D

@export var checkpoint_name := "Checkpoint"
var activated := false

@onready var flag: Node3D = $Visual

func _on_body_entered(body: Node3D) -> void:
	if activated or not body.is_in_group("Player"):
		return
	activated = true
	if body.has_method("set_spawn_point"):
		body.set_spawn_point(global_position)
	AudioManager.coin_sfx.pitch_scale = 0.8
	AudioManager.coin_sfx.play()
	var tween := create_tween()
	tween.tween_property(flag, "scale", Vector3(1.3, 1.3, 1.3), 0.15)
	tween.tween_property(flag, "scale", Vector3.ONE, 0.15)
