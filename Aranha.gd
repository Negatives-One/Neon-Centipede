extends KinematicBody2D

var dir : int = -1
var motion : Vector2 = Vector2()
var points : PackedScene = help.points

func _ready() -> void:
	if global_position.x < 300:
		dir = 1
	else:
		dir = -1

func _physics_process(delta) -> void:
	SairDaTela()
	motion.y += 8
	move()
	if $RayCast2D.is_colliding():
		var colider = $RayCast2D.get_collider()
		if colider.is_in_group('Sobe'):
			jump()
	var colision : KinematicCollision2D = move_and_collide(motion*delta)
	if colision != null:
		var collider : CollisionObject2D = colision.get_collider()
		if collider.is_in_group('Player'):
			get_tree().reload_current_scene()
		elif collider.is_in_group('Bala'):
			collider.queue_free()
			queue_free()
		else:
			pass

func SelectDir() -> int:
	var dir : int# = int(rand_range(-2, 2))
	if global_position.x < 490:
		var chance : Array = [-1, 0, 1, 1]
		dir = chance[randi() % chance.size()]
	elif global_position.x < 981:
		dir = int(rand_range(-2, 2))
	else:
		var chance : Array = [-1, 0, 1, -1]
		dir = chance[randi() % chance.size()]
	if dir == 0:
		$Timer.set_wait_time(2)
	elif dir == 1 or dir == -1:
		$Timer.set_wait_time(5)
	$Timer.start()
	return dir

func move() -> void:
	motion.x = dir*100

func jump() -> void:
	var a : int = randi() % 3+1
	if a == 1:
		motion.y = -400
	elif a > 1:
		motion.y = -550 

func _on_Timer_timeout() -> void:
	dir = SelectDir()

func SairDaTela() -> void:
	if self.global_position.x > 1540 or self.global_position.x < -132:
		help.Aranha = false
		queue_free()

func morre() -> void:
	help.Aranha = false
	queue_free()

func ShowPoints(quanto : int) -> void:
	var text : Node = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func _on_Area2D_body_entered(body) -> void:
	if body.is_in_group('Cogumelo'):
		body.queue_free()
	if body.is_in_group('Bala'):
		if body.distToPlayer() <= 150:
			help.score += 900
			ShowPoints(900)
		elif body.distToPlayer() <= 250:
			help.score += 600
			ShowPoints(600)
		elif body.distToPlayer() > 250:
			help.score += 300
			ShowPoints(300)
		body.queue_free()
		morre()
	if body.is_in_group('Player'):
		get_tree().reload_current_scene()
