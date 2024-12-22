extends Control

@onready var settings = $Settings
@onready var credits = $Credits


func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	settings.visible = true


func _on_jouer_pressed():
	get_tree().change_scene_to_file("res://level/map.tscn")


func _on_credits_pressed():
	credits.visible = true
