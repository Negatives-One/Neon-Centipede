extends Area2D

var orien = 1

func _physics_process(_delta):
	var cogumelo = get_overlapping_bodies()
	for i in range(len(cogumelo)):
		if cogumelo[i].is_in_group("Cogumelo"):
			cogumelo[i].especial = true
	self.global_position.x += orien * 2


func _on_KinematicBody2D_body_entered(body):
	if body.is_in_group('Bala'):
		body.queue_free()
		help.score += 1000
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
