extends Node3D

var toggle = false
var interactable = true
@export var anim: AnimationPlayer

func interact():
	if interactable == true:
		interactable = false
		toggle = !toggle
		if toggle == false:
			anim.play("close")
		if toggle == true:
			anim.play("open")
		await get_tree().create_timer(1.0, false).timeout
		interactable = true
