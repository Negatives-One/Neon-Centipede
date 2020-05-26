extends KinematicBody2D

var dir = -1
var motion = Vector2()
onready var points = preload("res://Points.tscn")

func _ready():
	SelectDir()

func _physics_process(delta):
	SairDaTela()
	motion.y += 8
	move()
	if $RayCast2D.is_colliding():
		var colider = $RayCast2D.get_collider()
		if colider.is_in_group('Sobe'):
			jump()
	var colision = move_and_collide(motion*delta)
	if colision != null:
		var collider = colision.get_collider()
		if collider.is_in_group('Player'):
			get_tree().reload_current_scene()
		elif collider.is_in_group('Bala'):
			collider.queue_free()
			queue_free()
		else:
			pass

func SelectDir():
	var aux = int(rand_range(-2, 2))
	if aux == 0:
		$Timer.set_wait_time(2)
	elif aux == 1 or aux == -1:
		$Timer.set_wait_time(5)
	$Timer.start()
	return aux

func move():
	motion.x = dir*100

func jump():
	var a = randi() % 3+1
	if a == 1:
		motion.y = -400
	elif a > 1:
		motion.y = -550 

func _on_Timer_timeout():
	dir = SelectDir()

func SairDaTela():
	if self.global_position.x > 1540 or self.global_position.x < -132:
		help.Aranha = false
		queue_free()

func morre():
	help.Aranha = false
	queue_free()

func ShowPoints(quanto):
	var text = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func _on_Area2D_body_entered(body):
	if body.is_in_group('Cogumelo'):
		body.queue_free()
	if body.is_in_group('Bala'):
		if body.distToPlayer() <= 107:
			help.score += 900
			ShowPoints(900)
		elif body.distToPlayer() <= 214:
			help.score += 600
			ShowPoints(600)
		elif body.distToPlayer() > 214:
			help.score += 300
			ShowPoints(300)
		body.queue_free()
		morre()
	if body.is_in_group('Player'):
		morre()
		get_tree().reload_current_scene()
