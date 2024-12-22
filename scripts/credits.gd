extends Control

@onready var credits = $"."


func _on_back_pressed():
	credits.visible = false
