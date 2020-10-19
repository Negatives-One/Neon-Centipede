extends KinematicBody2D

export var velocidade : int = 2200
var motion : Vector2 = Vector2(0, -1)


func _physics_process(delta) -> void:
	var collision : KinematicCollision2D = move_and_collide(motion * velocidade * delta)
	if collision != null:
		var collider = collision.get_collider()
		help.CanShoot = true
		if collider.is_in_group('Centipede'):
			queue_free()
			collider.morto()
			collider.vivo = false
			collider.CreateCogu()
		if collider.is_in_group('Cogumelo'):
			queue_free()
			collider.Damage()

func distToPlayer() -> float:
	var dist = self.global_position.distance_to($"../KinematicBody2D".global_position)
	return dist

func _on_VisibilityNotifier2D_screen_exited() -> void:
	help.CanShoot = true
	queue_free()
