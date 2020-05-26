extends Area2D

var PodeFazer = true
var moveSpeed = 200
var vida = 2
export (int) var UmACada = 2
onready var aux = self.global_position.y + 160
onready var start = self.global_position.y

onready var cogumelo = preload("res://Cogumelo.tscn")
onready var points = preload("res://Points.tscn")

func _physics_process(delta):
	verifica()
	if self.global_position.y >= aux+32:
		randomize()
		var deveria = randi() % UmACada
		if deveria == 0:
			if self.global_position.y <= 1088 and self.global_position.y >= 96:
#				if PodeFazer:
#					pass
				CreateCogu(Vector2(self.position.x - 32, aux))
		aux += 64
	self.global_position.y += moveSpeed*delta


func CreateCogu(posic):
	var mush = cogumelo.instance()
	$"../../Cogumelos".call_deferred('add_child', mush)
	mush.global_position = posic


func _on_VisibilityNotifier2D_screen_exited():
	help.Conchinha = false

func ShowPoints(quanto):
	var text = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func verifica():
	var a = self.get_overlapping_bodies()
	for i in a:
		if i.is_in_group('Bala'):
			vida += -1
			i.queue_free()
			if vida == 1:
				moveSpeed = 400
			if vida == 0:
				help.score += 200
				ShowPoints(200)
				self.queue_free()
		if i.is_in_group('Player'):
			get_tree().reload_current_scene()
		if i.is_in_group('Cogumelo'):
			PodeFazer = false
			return
	PodeFazer = true
