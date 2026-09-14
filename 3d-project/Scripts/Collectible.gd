# ไอเทมที่ต้องเก็บให้ครบในแต่ละฉาก (ต่อยอดจาก Coin.gd ของ Starter Kit)
extends Area3D

@export_category("Properties")
@export var follow_speed := 7.0
@export var amplitude := 0.2
@export var frequency := 4.0
@export var spin_speed := 90.0

var time_passed := 0.0
var is_in_range := false
var taken := false
var initial_position := Vector3.ZERO

@onready var player := get_tree().get_first_node_in_group("Player")

func _ready() -> void:
	initial_position = position
	time_passed = randf() * TAU

func _process(delta: float) -> void:
	time_passed += delta
	position.y = initial_position.y + amplitude * sin(frequency * time_passed)
	rotate_y(deg_to_rad(spin_speed * delta))

	if is_in_range and is_instance_valid(player):
		position += global_position.direction_to(player.global_position) * follow_speed * delta

func _on_body_entered(body: Node3D) -> void:
	if taken:
		return
	if body.is_in_group("Player"):
		taken = true
		GameManager.add_item()
		AudioManager.coin_sfx.pitch_scale = randf_range(1.05, 1.35)
		AudioManager.coin_sfx.play()
		var tween := create_tween()
		tween.tween_property(self, "scale", Vector3.ZERO, 0.15)
		await tween.finished
		queue_free()

func _on_range_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_in_range = true

func _on_range_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		is_in_range = false
