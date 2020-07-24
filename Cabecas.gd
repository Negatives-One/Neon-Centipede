extends Node2D

var posicao : Vector2 = Vector2(768, 32)
export (int) var tamanho : int = 9
var parte : PackedScene = preload("res://Centipede.tscn")

func _ready() -> void:
	Summon()

func Summon() -> void:
	for _i in range(tamanho):
		NewPart()
		posicao.x += 64
	posicao.x = 768

func _physics_process(_delta):
	var mortos : Array = [0, 0, 0, 0, 0, 0, 0, 0, 0]
	for j in range(len(self.get_children())):
		if self.get_children()[j].vivo == false:
			mortos[j] = 1

	if soma(mortos) == tamanho:
		mortos = zerar(mortos)
		deleteDead()
		Summon()

func deleteDead() -> void:
	for i in self.get_children():
		i.queue_free()

func zerar(array) -> Array:
	for i in array:
		i = 0
	return array

func soma(array) -> int:
	var a : int = 0
	for i in array:
		a += i
	return a

func NewPart() -> void:
	var NovaParte : Node = parte.instance()
	self.call_deferred('add_child', NovaParte)
	NovaParte.global_position = posicao
	NovaParte.aux = posicao.x
