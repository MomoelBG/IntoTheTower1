extends Control


func _on_quit_pressed():
	get_tree().quit()


func _on_titlescreen_pressed():
	get_tree().change_scene_to_file("res://level/Title.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://level/PauseSettings.tscn")
