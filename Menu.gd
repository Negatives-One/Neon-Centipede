extends Node

func _on_Button_pressed() -> void:
	get_tree().change_scene("res://cena.tscn")

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		OS.window_fullscreen = !OS.window_fullscreen
