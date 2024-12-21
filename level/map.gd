extends Node3D

@onready var player = $Player
@onready var tp = $tp

#respawn
func _on_area_3d_area_entered(area):
	player.position = tp.position
