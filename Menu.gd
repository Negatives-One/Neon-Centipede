extends Control

var isIn : bool = false

func _ready():
	$"../AnimationPlayer".play("pisca")
	$"../AnimationPlayer2".play("color")


func _process(delta):
	if(get_global_mouse_position().x > 580 and get_global_mouse_position().x < 1575):
		if get_global_mouse_position().y > 460 and get_global_mouse_position().y < 957.5:
			if(Input.is_action_just_pressed("click")):
				get_tree().change_scene("res://cena.tscn")
	if Input.is_action_just_pressed("esc"):
		OS.window_fullscreen = !OS.window_fullscreen


