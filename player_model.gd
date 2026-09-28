extends Node3D

# The player root handles movement and turning.
# This script is intentionally kept passive so the model does not fight the controller.

func _ready():
	set_process(false)
