# ----------------------------------------------------------------------------- #
#  Player Controller
#  ต่อยอดจาก 3D Platformer Starter Kit (SD Studios, CC0)
#  แก้ไข: เปลี่ยนโมเดลตัวละครเป็น Poly Pizza (Quaternius - Animated Men Pack)
#         และ map ชุดท่าทางใหม่เข้ากับชื่อ animation เดิมของ Starter Kit
#         (Idle / Run / Jump / Flip) ผ่าน AnimationLibrary "HeroAnimations.tres"
# ----------------------------------------------------------------------------- #

extends CharacterBody3D

@export_category("Player Properties")
@export var move_speed: float = 6.0
@export var jump_force: float = 6.0
@export var follow_lerp_factor: float = 4.0

@export_group("Model")
## หมุนโมเดลชดเชย เพราะโมเดลจาก Poly Pizza หันหน้าคนละทางกับ gobot เดิม
@export var model_yaw_offset_deg: float = 0.0

@export_group("Game Juice")
@export var jumpStretchSize := Vector3(0.85, 1.15, 0.85)

var is_grounded := false
var can_double_jump := false
var is_dead := false
var spawn_point := Vector3.ZERO

@onready var model: Node3D = $Model
@onready var animation: AnimationPlayer = $Model/AnimationPlayer
@onready var spring_arm: Node3D = %Gimbal
@onready var particle_trail: CPUParticles3D = $ParticleTrail
@onready var footsteps: AudioStreamPlayer3D = $Footsteps

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") * 2.0

func _ready() -> void:
	spawn_point = global_position
	# กันพลาด: ถ้า AnimationLibrary ที่ map ชื่อท่าไว้ยังไม่ถูกผูกกับ AnimationPlayer
	# (เช่นตอน re-import โมเดล) ให้โหลดใส่ให้อัตโนมัติ
	if not animation.has_animation("Idle"):
		var lib: AnimationLibrary = load("res://Assets/Models/Character/HeroAnimations.tres")
		if animation.has_animation_library(""):
			animation.remove_animation_library("")
		animation.add_animation_library("", lib)
	animation.play("Idle")

func _process(delta: float) -> void:
	if is_dead:
		spring_arm.position = lerp(spring_arm.position, position, delta * follow_lerp_factor)
		return

	player_animations()
	get_input(delta)

	spring_arm.position = lerp(spring_arm.position, position, delta * follow_lerp_factor)

	if is_moving():
		var look_direction := Vector2(velocity.z, velocity.x)
		var target := look_direction.angle() + deg_to_rad(model_yaw_offset_deg)
		model.rotation.y = lerp_angle(model.rotation.y, target, delta * 12.0)

	# กันพลาดตอนเครื่องช้า/เฟรมตก: ถ้าร่วงต่ำกว่าขอบเขตโลกให้ถือว่าตาย
	if global_position.y < -40.0:
		die()
		return

	is_grounded = is_on_floor()
	if is_grounded:
		can_double_jump = true

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			perform_jump()
		elif can_double_jump and is_moving():
			perform_flip_jump()

	velocity.y -= gravity * delta

func perform_jump() -> void:
	AudioManager.jump_sfx.pitch_scale = 1.12
	AudioManager.jump_sfx.play()
	jumpTween()
	animation.play("Jump")
	velocity.y = jump_force

func perform_flip_jump() -> void:
	AudioManager.jump_sfx.pitch_scale = 0.8
	AudioManager.jump_sfx.play()
	animation.play("Flip", -1, 1.5)
	velocity.y = jump_force
	can_double_jump = false

func is_moving() -> bool:
	return absf(velocity.z) > 0.1 or absf(velocity.x) > 0.1

func jumpTween() -> void:
	var tween := create_tween()
	tween.tween_property(self, "scale", jumpStretchSize, 0.1)
	tween.tween_property(self, "scale", Vector3.ONE, 0.1)

func get_input(_delta: float) -> void:
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_back")
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	velocity = Vector3(move_direction.x * move_speed, velocity.y, move_direction.z * move_speed)
	move_and_slide()

func player_animations() -> void:
	particle_trail.emitting = false
	footsteps.stream_paused = true

	if is_on_floor():
		if is_moving():
			animation.play("Run", 0.2)
			particle_trail.emitting = true
			footsteps.stream_paused = false
		else:
			animation.play("Idle", 0.3)

# ---------- ตาย / เกิดใหม่ ---------- #

func set_spawn_point(pos: Vector3) -> void:
	spawn_point = pos

func die() -> void:
	if is_dead:
		return
	is_dead = true
	velocity = Vector3.ZERO
	particle_trail.emitting = false
	footsteps.stream_paused = true
	animation.play("Death")
	GameManager.add_death()
	await get_tree().create_timer(1.2).timeout
	respawn()

func respawn() -> void:
	global_position = spawn_point + Vector3(0, 0.5, 0)
	velocity = Vector3.ZERO
	scale = Vector3.ONE
	is_dead = false
	animation.play("Idle")
