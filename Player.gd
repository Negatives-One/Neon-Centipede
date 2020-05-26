extends KinematicBody2D

var MoveVector = [0, 0]
var motion = Vector2()
const MoveSpeed = 256*2
var bullet = preload("res://Bullet.tscn")
var V

func _physics_process(_delta):
	get_movedir()
	Movimento()
	Shoot()
	V = move_and_slide(motion)


func MoveVerticalInput():
	if Input.is_action_pressed("ui_up"):
		MoveVector[1] = -1
	elif Input.is_action_pressed("ui_down"):
		MoveVector[1] = 1
	else:
		MoveVector[1] = 0

func MoveHorizontalInput():
	if Input.is_action_pressed("ui_left"):
		MoveVector[0] = -1
	elif Input.is_action_pressed("ui_right"):
		MoveVector[0] = 1
	else:
		MoveVector[0] = 0

func get_movedir():
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	motion = Vector2(-int(LEFT) + int(RIGHT), -int(UP) + int(DOWN)).normalized()

func Shoot():
	if Input.is_action_pressed("Space"):
		if help.CanShoot:
			help.CanShoot = false
			new_bullet()


func new_bullet():
	var new_bullet = bullet.instance()
	get_parent().call_deferred('add_child', new_bullet)
	new_bullet.position = $Position2D.global_position


func Movimento():
	motion = motion * MoveSpeed
