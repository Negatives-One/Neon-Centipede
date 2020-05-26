extends StaticBody2D

var vida = 3
var especial = false
onready var Cogumelos = $"..".get_children()
onready var points = preload("res://Points.tscn")

func _physics_process(_delta):
	Cogumelos = $"..".get_children()
	Verify()
	$AnimatedSprite.set_frame(vida)
	if vida <= -1:
		help.score += 1
		ShowPoints(1)
		queue_free()
	if especial == true:
		self_modulate = Color(0, 0, 1, 1 )

func ShowPoints(quanto):
	var text = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func passando():
	$CollisionShape2D.disabled = true

func taDentro():
	var d = $Area2D.get_overlapping_bodies()
	if len(d) > 0:
		return true

func _on_Area2D_body_exited(_body):
	$Timer.start()

func Verify():
	for i in range(len(Cogumelos)):
		if Cogumelos[i].global_position == self.global_position and Cogumelos[i] != self:
			Cogumelos[i].queue_free()

func morre():
	call_deferred('queue_free')

func _on_Timer_timeout():
	$CollisionShape2D.disabled = false
