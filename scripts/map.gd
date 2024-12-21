extends Node3D


@onready var title_screen = $TitleScreen


func _ready():
	title_screen.visible = false
