extends KinematicBody2D


onready var cogumelo : PackedScene = preload("res://Cogumelo.tscn")
var points : PackedScene = help.points
var aux
var auy = 64
var vivo : bool = true
var pos : Array = []
var partes : Array = []
var subindo : bool = false
var facing : int = -1
var motion : Vector2 = Vector2()
var MoveSpeed : int = 256
export (int) var tamanho : int = 9

var despencando : bool = false

func _physics_process(delta) -> void:
	skin()
	if self.position.y <= 800:
		$"../..".MadnessTime = true
		subindo = false
	if vivo == true:
		if despencando:
			$Sprite.rotation = 1.5708
			motion = Vector2(0, MoveSpeed)
			var collision = move_and_collide(motion*delta)
			if collision != null:
				var collider = collision.get_collider()
				if collider.is_in_group('Cogumelo'):
					collider.passando()
				elif collider.is_in_group('Parede'):
					despencando = false
				elif collider.is_in_group('Player'):
					get_tree().reload_current_scene()
		else:
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
					if collider.is_in_group('Cogumelo'):
						if collider.especial == true:
							despencando = true
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
							x.passando()
						self.global_position.y += -64
						auy += -64
				if collider.is_in_group('Player'):
					get_tree().reload_current_scene()

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

func HitCogu() -> void:
	facing = false

func ShowPoints(quanto) -> void:
	var text : Node = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	$"../..".call_deferred('add_child', text)

func morto() -> void:
		help.score += 100
		ShowPoints(100)
		$Light2D.enabled = false
		$Sprite.visible = false
		$CollisionShape2D.disabled = true

func CreateCogu() -> void:
	var mush : Node = cogumelo.instance()
	$"../../Cogumelos".call_deferred('add_child', mush)
	mush.global_position = Vector2(aux -32, auy - 32)
	var cogumelos : Array = $"../../Cogumelos".get_children()
	for i in cogumelos:
		i.call_deferred("Verify")

func _on_VisibilityNotifier2D_screen_exited() -> void:
	vivo = false
