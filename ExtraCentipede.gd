extends KinematicBody2D

onready var cogumelo : PackedScene = preload("res://Cogumelo.tscn")
var subindo : bool = false
var facing : int = 1
var motion : Vector2 = Vector2.ZERO
var MoveSpeed : int = 256
var vivo : bool = true
var aux : int
var auy : int = 64

func _ready():
	if global_position.x < 300:
		facing = 1
	else:
		facing = -1
	auy = global_position.y

func _physics_process(delta):
	skin()
	if self.position.y <= 800:
		subindo = false
	if self.global_position.x > 64 and self.global_position.x < 1376:
		$CollisionShape2D.disabled = false
	if vivo == true:
		rot()
		movimento()
		if facing == -1 and self.global_position.x < aux:
			aux -= 64
		elif facing == 1 and self.global_position.x > aux:
			aux += 64
		var collision = move_and_collide(motion*delta)
		if collision != null:
			var collider = collision.get_collider()
			if collider.is_in_group('Parede'):
				facing *= -1
				$Up.cast_to.y *= -1
				$UpSkin.cast_to.y *= -1
				$Down.cast_to.y *= -1
				$DownSkin.cast_to.y *= -1
				if subindo == false:
					if $Down.is_colliding():
						var x = $Down.get_collider()
						if x.is_in_group('Cogumelo'):
							x.passando()
						if x.is_in_group('Sobe'):
							subindo = true
							self.global_position.y += -128
							auy += -128
					self.global_position.y += 64
					auy += 64
				else:
					if $Up.is_colliding():
						var x = $Up.get_collider()
						if x.is_in_group('Cogumelo'):
							x.passando()
					self.global_position.y += -64
					auy += -64
			if collider.is_in_group('Player'):
				help.DamagePlayer()

func movimento() -> void:
	motion.x = facing * MoveSpeed

func skin() -> void:
	if $Front.is_colliding():
		$Sprite/Mandibula.visible = false
	else:
		$Sprite/Mandibula.visible = true
	
	if $Back.is_colliding():
		$Sprite/Calda.visible = false
	else:
		$Sprite/Calda.visible = true

func rot() -> void:
	if facing == 1:
		self.rotation = 0
	elif facing == -1:
		self.rotation = PI#3.14159

func ShowPoints(quanto) -> void:
	var text : Node = help.points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	$"../..".call_deferred('add_child', text)

func morto() -> void:
		help.score += 100
		ShowPoints(100)
		queue_free()

func CreateCogu() -> void:
	var mush : Node = cogumelo.instance()
	$"../../Cogumelos".call_deferred('add_child', mush)
	mush.global_position = Vector2(aux -32, auy - 32)
	var cogumelos : Array = $"../../Cogumelos".get_children()
	for i in cogumelos:
		i.call_deferred("Verify")
