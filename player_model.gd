extends Node3D

func _process(delta):
	var direction = Vector3.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.z -= 1

	if Input.is_key_pressed(KEY_S):
		direction.z += 1

	if Input.is_key_pressed(KEY_A):
		direction.x -= 1

	if Input.is_key_pressed(KEY_D):
		direction.x += 1

	if direction.length() > 0:
		direction = direction.normalized()
		var target_rotation = atan2(direction.x, direction.z) + PI
		rotation.y = lerp_angle(rotation.y, target_rotation, 8.0 * delta)
