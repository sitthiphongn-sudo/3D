extends Control

@onready var items_label: Label = $Panel/VBox/ItemsLabel
@onready var level_label: Label = $Panel/VBox/LevelLabel
@onready var hint_label: Label = $HintLabel

func _ready() -> void:
	GameManager.items_changed.connect(_refresh)
	_refresh(GameManager.items_collected, GameManager.items_total)

func _process(_delta: float) -> void:
	level_label.text = GameManager.current_level_name

func _refresh(collected: int, total: int) -> void:
	items_label.text = "RELICS   %d / %d" % [collected, total]
	if collected >= total and total > 0:
		hint_label.text = "All relics found - head to the gate!"
		hint_label.modulate = Color(0.6, 1, 0.6)
	else:
		hint_label.text = "WASD move   SPACE jump (double-tap = flip)   MOUSE look   R restart"
		hint_label.modulate = Color(1, 1, 1, 0.75)
