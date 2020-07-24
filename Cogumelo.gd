extends StaticBody2D

var vida : int = 3
var especial : bool = false
#onready var Cogumelos : Array = $"..".get_children()
var points : PackedScene = help.points

func _ready():
	$AnimatedSprite.set_frame(vida)

func _physics_process(_delta) -> void:
	if especial == true:
		self_modulate = Color(0, 0, 1, 1 )

func ShowPoints(quanto) -> void:
	var text : Node = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func passando() -> void:
	$CollisionShape2D.disabled = true

func taDentro() -> bool:
	var d : Array = $Area2D.get_overlapping_bodies()
	if len(d) > 0:
		return true
	else:
		return false

func _on_Area2D_body_exited(_body) -> void:
	$Timer.start()

func Verify() -> void:
	var Cogumelos : Array = get_parent().get_children()
	for i in range(len(Cogumelos)):
		if Cogumelos[i].global_position == self.global_position and Cogumelos[i] != self:
			Cogumelos[i].queue_free()

func morre() -> void:
	call_deferred('queue_free')

func _on_Timer_timeout() -> void:
	$CollisionShape2D.disabled = false

func Damage() -> void:
	vida -= 1
	if vida <= -1:
		help.score += 1
		ShowPoints(1)
		queue_free()
	$AnimatedSprite.set_frame(vida)
