extends Node3D

@export var speed := 5.0
@export var turn_speed := 10.0

func _process(delta):
	var direction := Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.z -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.z += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0

	if direction.length_squared() > 0.0:
		direction = direction.normalized()
		position += direction * speed * delta

		var target_rotation := atan2(direction.x, direction.z) + PI
		rotation.y = lerp_angle(rotation.y, target_rotation, turn_speed * delta)
