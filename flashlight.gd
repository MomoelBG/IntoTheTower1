extends Node3D


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Toggle"):
		$SpotLight3D.light_energy = 32
	else:
		$SpotLight3D.light_energy = 0
