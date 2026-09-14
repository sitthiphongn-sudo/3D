# ประตูไปด่านถัดไป — เปิดได้เมื่อเก็บไอเทมครบ
extends Area3D

@export var next_level := 2
@export var door_label := "GATE"

var opened := false

@onready var locked_visual: Node3D = $Locked
@onready var hint: Label3D = $Hint

func _ready() -> void:
	GameManager.items_changed.connect(_on_items_changed)
	_on_items_changed(GameManager.items_collected, GameManager.items_total)

func _on_items_changed(collected: int, total: int) -> void:
	if collected >= total and total > 0:
		_open()
	else:
		hint.text = "%s  -  LOCKED\nCollect all relics  %d / %d" % [door_label, collected, total]

func _open() -> void:
	if opened:
		return
	opened = true
	hint.text = "%s  -  OPEN\nEnter the gate!" % door_label
	hint.modulate = Color(0.65, 1.0, 0.6)
	var tween := create_tween()
	tween.tween_property(locked_visual, "position:y", -3.2, 0.8).set_trans(Tween.TRANS_CUBIC)

func _on_body_entered(body: Node3D) -> void:
	if opened and body.is_in_group("Player"):
		set_deferred("monitoring", false)
		GameManager.go_to_level(next_level)
