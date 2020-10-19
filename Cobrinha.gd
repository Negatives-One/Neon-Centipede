extends Area2D

var orien : int = 0
export(int) var speed : int = 300
var killed : bool = false

var Passados : Array = []

func _ready() -> void:
	if global_position.x < 300:
		orien = 1
		$Sprite.flip_h = true
	else:
		orien = -1
		$Sprite.flip_h = false

func _physics_process(delta) -> void:
	print(Passados)
	self.global_position.x += orien * speed * delta


func _on_KinematicBody2D_body_entered(body):
	if body.is_in_group('Bala'):
		killed = true
		body.queue_free()
		help.Cobrinha = false
		help.score += 1000
		ShowPoints(1000)
		queue_free()
	elif body.is_in_group("Cogumelo"):
		Passados.append(body)

func ShowPoints(quanto : int) -> void:
	var text : Node = help.points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func _on_VisibilityNotifier2D_screen_exited():
	if(!killed):
		for i in range(len(Passados)):
			Passados[i].especial()
		help.Cobrinha = false
		queue_free()
