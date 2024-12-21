extends Node3D


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Toggle"):
		$SpotLight3D.light_energy = 30
	else:
		$SpotLight3D.light_energy = 0
