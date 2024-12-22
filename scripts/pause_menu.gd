extends Control

@onready var settings = $Settings
@onready var pause_menu = $"."
@onready var credits = $Credits


func _on_quit_pressed():
	get_tree().quit()


func _on_titlescreen_pressed():
	get_tree().change_scene_to_file("res://level/Title.tscn")


func _on_settings_pressed():
	settings.visible = true

func _on_continue_pressed():
	pause_menu.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_reload_pressed():
	get_tree().reload_current_scene()

func _on_credits_pressed():
	credits.visible = true
