extends Area2D

var PodeFazer : bool = true
var moveSpeed : int = 200
var vida : int = 2
export (int) var UmACada : int = 2
onready var aux : float = self.global_position.y + 160
onready var start : float = self.global_position.y
onready var cogumelo : PackedScene = preload("res://Cogumelo.tscn")
var points : PackedScene = help.points

func _process(_delta) -> void:
	verifica()
	if self.global_position.y >= aux+32:
		var deveria : int = randi() % UmACada
		if deveria == 0:
			if self.global_position.y <= 1088 and self.global_position.y >= 96:
#				if PodeFazer:
#					pass
				CreateCogu(Vector2(self.position.x - 32, aux))
		aux += 64

func _physics_process(delta) -> void:
	self.global_position.y += moveSpeed * delta


func CreateCogu(posic) -> void:
	var mush : Node = cogumelo.instance()
	$"../../Cogumelos".call_deferred('add_child', mush)
	mush.global_position = posic
	var cogumelos : Array = $"../../Cogumelos".get_children()
	for i in cogumelos:
		i.call_deferred("Verify")


func _on_VisibilityNotifier2D_screen_exited() -> void:
	help.Conchinha = false

func ShowPoints(quanto) -> void:
	var text : Node = points.instance()
	text.global_position = self.global_position
	text.velocity = Vector2(rand_range(-50, 50), -100)
	text.modulate = Color(rand_range(0.7, 1), rand_range(0.7, 1), rand_range(0.7, 1), 1)
	
	text.text = quanto
	
	get_parent().call_deferred('add_child', text)

func verifica() -> void:
	var a : Array = self.get_overlapping_bodies()
	if(a.size() > 0):
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
	else:
		pass
