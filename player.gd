extends Node3D

@export var walk_speed := 4.0
@export var run_speed := 7.0
@export var turn_speed := 10.0
@export var attack_cooldown := 0.45

var can_attack := true
var is_dead := false
var animation_player: AnimationPlayer

func _ready():
	animation_player = _find_animation_player(self)
	_play_animation_by_names(["Idle", "idle", "RESET", "reset"])

func _process(delta):
	if is_dead:
		return

	var direction := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.z += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0

	var moving := direction.length_squared() > 0.0

	if moving:
		direction = direction.normalized()
		var current_speed := run_speed if Input.is_key_pressed(KEY_SHIFT) else walk_speed
		position += direction * current_speed * delta

		var target_rotation := atan2(direction.x, direction.z) + PI
		rotation.y = lerp_angle(rotation.y, target_rotation, turn_speed * delta)

		if Input.is_key_pressed(KEY_SHIFT):
			_play_animation_by_names(["Run", "run", "Running", "running"])
		else:
			_play_animation_by_names(["Walk", "walk", "Walking", "walking"])
	else:
		_play_animation_by_names(["Idle", "idle", "RESET", "reset"])

	if Input.is_key_pressed(KEY_SPACE) or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack()

	# Testing controls:
	# H = hit reaction, K = death.
	if Input.is_key_pressed(KEY_H):
		hit()
	if Input.is_key_pressed(KEY_K):
		die()

func attack():
	if not can_attack or is_dead:
		return

	can_attack = false
	_play_animation_by_names(["Attack", "attack", "Attack1", "attack1", "Slash", "slash"])
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func hit():
	if is_dead:
		return
	_play_animation_by_names(["Hit", "hit", "Hurt", "hurt", "TakeDamage", "takedamage"])

func die():
	if is_dead:
		return

	is_dead = true
	_play_animation_by_names(["Death", "death", "Die", "die"])

func _find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node

	for child in node.get_children():
		var result := _find_animation_player(child)
		if result:
			return result

	return null

func _play_animation_by_names(names: Array[String]):
	if animation_player == null:
		return

	var library := animation_player.get_animation_library("")
	if library == null:
		return

	for animation_name in names:
		if library.has_animation(animation_name):
			animation_player.play(animation_name)
			return
