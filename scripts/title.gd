extends Control

@onready var settings = $Settings
@onready var title_screen = $"."


func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://level/map.tscn")

func _on_settings_pressed():
	settings.visible = true
