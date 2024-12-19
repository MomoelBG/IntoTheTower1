extends Control

@onready var audio = $audio
@onready var resolution = $resolution
@onready var controls = $Controls

func _on_button_pressed():
	get_tree().change_scene_to_file("res://level/PauseMenu.tscn")


func _on_audio_pressed():
	audio.visible = true
	resolution.visible = false
	controls.visible = false

func _on_resolution_pressed():
	audio.visible = false
	controls.visible = false
	resolution.visible = true

func _on_controls_pressed():
	audio.visible = false
	resolution.visible = false
	controls.visible = true


func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)

func _on_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1152,648))
		1:
			DisplayServer.window_set_size(Vector2i(800,500))


func _on_check_button_pressed():
	pass
