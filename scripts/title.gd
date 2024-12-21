extends Control

@onready var settings = $Settings
@onready var title_screen = $"."

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	settings.visible = true
