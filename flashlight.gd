extends Node3D

@export_category("light")
@export var lightint = 15

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Toggle"):
		$SpotLight3D.light_energy = lightint
	else:
		if Input.is_action_just_pressed("toggle"):
			$SpotLight3D.light_energy = 0
