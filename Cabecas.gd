extends Node2D

var posicao = Vector2(768, 32)
export (int) var tamanho = 9
var parte = preload("res://Centipede.tscn")

func _ready():
	Summon()

func Summon():
	for _i in range(tamanho):
		NewPart()
		posicao.x += 64
	posicao.x = 768

func _physics_process(_delta):
	var mortos = [0,0,0,0,0,0,0,0,0]
	for j in range(len(self.get_children())):
		if self.get_children()[j].vivo == false:
			mortos[j] = 1

	if soma(mortos) == 9:
		mortos = zerar(mortos)
		deleteDead()
		Summon()

func deleteDead():
	for i in self.get_children():
		i.queue_free()

func zerar(array):
	for i in array:
		i = 0
	return array

func soma(array):
	var a = 0
	for i in array:
		a += i
	return a

func NewPart():
	var NovaParte = parte.instance()
	self.call_deferred('add_child', NovaParte)
	NovaParte.global_position = posicao
	NovaParte.aux = posicao.x
