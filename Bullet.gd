extends KinematicBody2D


var velocidade = 2500
var motion = Vector2(0, -1)
var colider

func _physics_process(delta):
	var collision = move_and_collide(motion * velocidade * delta)
	if collision != null:
		var collider = collision.get_collider()
		help.CanShoot = true
		if collider.is_in_group('Centipede'):
			queue_free()
			collider.vivo = false
			collider.CreateCogu()
		if collider.is_in_group('Cogumelo'):
			queue_free()
			collider.vida -= 1

func distToPlayer():
	var dist = self.global_position.distance_to($"../KinematicBody2D".global_position)
	return dist

func _on_VisibilityNotifier2D_screen_exited():
	help.CanShoot = true
	queue_free()
