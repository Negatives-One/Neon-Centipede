extends KinematicBody2D


onready var cogumelo = preload("res://Cogumelo.tscn")
onready var points = preload("res://Points.tscn")
var morreu = false
var aux
var auy = 64
var vivo = true
var pos = []
var partes = []
var subindo = false
var facing = -1
var motion = Vector2()
var MoveSpeed = 256
export (int) var tamanho = 9




func _physics_process(delta):
	skin()
	if self.position.y <= 800:
		subindo = false
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
				if facing == -1:
					$Up.cast_to.y = -64
					$UpSkin.cast_to.y = -10
					$Down.cast_to.y = 64
					$DownSkin.cast_to.y = 10
					facing = 1
				elif facing == 1:
					$Up.cast_to.y = 64
					$UpSkin.cast_to.y = 10
					$Down.cast_to.y = -64
					$DownSkin.cast_to.y = -10
					facing = -1
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
	morto()

func movimento():
	motion.x = facing * MoveSpeed



func skin():
	if $Front.is_colliding():
		$Sprite/Mandibula.visible = false
	else:
		$Sprite/Mandibula.visible = true
	
	if $Back.is_colliding():
		$Sprite/Calda.visible = false
	else:
		$Sprite/Calda.visible = true
#
#	if $UpSkin.is_colliding():
#		$Sprite/Calda.visible = false
#	if $DownSkin.is_colliding():
#		$Sprite/Mandibula.visible = false


func rot():
	if facing == 1:
		self.rotation = 0
	elif facing == -1:
		self.rotation = 3.14159

func HitCogu():
	facing = false

func ShowPoints(quanto):
	var text = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	$"../..".call_deferred('add_child', text)

func morto():
	if vivo == false:
		if morreu == false:
			help.score += 100
			ShowPoints(100)
			morreu = true
		$Light2D.enabled = false
		$Sprite.visible = false
		$CollisionShape2D.disabled = true

func CreateCogu():
	var mush = cogumelo.instance()
	$"../../Cogumelos".call_deferred('add_child', mush)
	mush.global_position = Vector2(aux -32, auy - 32)

func _on_VisibilityNotifier2D_screen_exited():
	vivo = false
