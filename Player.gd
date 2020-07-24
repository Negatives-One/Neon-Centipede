extends KinematicBody2D

var MoveVector : Vector2 = Vector2(0, 0)
var motion : Vector2 = Vector2()
const MoveSpeed : int = 256*2
var bullet : PackedScene = preload("res://Bullet.tscn")

func _physics_process(_delta) -> void:
	get_movedir()
	motion = motion * MoveSpeed
	Shoot()
	motion = move_and_slide(motion)

func get_movedir() -> void:
	var LEFT : float = Input.get_action_strength("ui_left")
	var RIGHT : float = Input.get_action_strength("ui_right")
	var UP : float = Input.get_action_strength("ui_up")
	var DOWN : float = Input.get_action_strength("ui_down")
	
	motion = Vector2(-LEFT + RIGHT, -UP + DOWN).normalized()

func Shoot() -> void:
	if Input.is_action_pressed("Space"):
		if help.CanShoot:
			help.CanShoot = false
			new_bullet()

func new_bullet() -> void:
	var new_bullet : Node = bullet.instance()
	get_parent().call_deferred('add_child', new_bullet)
	new_bullet.position = $Position2D.global_position
