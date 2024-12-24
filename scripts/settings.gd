extends Control

@onready var audio = $audio
@onready var resolution = $resolution
@onready var controles = $controles
@onready var settings: Control = $"."
@onready var input_settings = $InputSettings


func _ready():
	visible = false


func _on_button_pressed():
	settings.visible = false



func _on_audio_pressed():
	audio.visible = true
	resolution.visible = false
	controles.visible = false
	input_settings.visible = false

func _on_resolution_pressed():
	audio.visible = false
	controles.visible = false
	resolution.visible = true
	input_settings.visible = false

func _on_controls_pressed():
	audio.visible = false
	resolution.visible = false
	controles.visible = true
	input_settings.visible = false

func _on_input_controls_pressed():
	input_settings.visible = true
	audio.visible = false
	resolution.visible = false
	controles.visible = false

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0,value)


func _on_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1152,648))
		1:
			DisplayServer.window_set_size(Vector2i(800,500))
