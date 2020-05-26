extends Node2D
#1440 direita
#-32 esquerda
var only = true
var cabecas
var taVivo = [0,0,0,0,0,0,0,0,0]
onready var SpawnCima = $Spawns/Topo.get_children()
onready var SpawnDirTopo = $Spawns/DireitaTopo.get_children()
onready var SpawnDirBaixo = $Spawns/DireitaBaixo.get_children()
onready var SpawnEsqTopo = $Spawns/EsquerdaTopo.get_children()
onready var SpawnEsqBaixo = $Spawns/EsquerdaBaixo.get_children()
var Cogumelos

onready var cogumelo = preload("res://Cogumelo.tscn")
onready var Aranha = preload("res://Aranha.tscn")
onready var ConchaObject = preload("res://conchinha.tscn")



var PositionAranha = Vector2.ZERO
var PositionConchinha = Vector2.ZERO



#18 blocos de altura
#22 blocos de comprimento

func _ready():
	$Node/TimerConcha.start()
	$Node/TimerAranha.start()
	setMap()
	set_physics_process(false)


func _physics_process(_delta):
	Cogumelos = $Cogumelos.get_children()
	help.CoguPlayerArea = NumCoguPlayerArea()
	SpawnAranha()
	SpawnConchinha()
	score()
	if Input.is_action_just_pressed("click"):
		CreateCogu(Vector2(get_global_mouse_position().x - 32, get_global_mouse_position().y - 32))
	cabecas = $Cabecas.get_children()

func score():
	$Control/Label.set_text(String(help.score))

func setMap():
	var y = 32+64
	var rand
	var oneOrTwo
	for _i in range(16):
		randomize()
		oneOrTwo = randi() % 2+1
		for _j in range(oneOrTwo):
			randomize()
			rand = randi() % 21 + 1
			CreateCogu(Vector2(rand*64+32, y))
#		randomize()
#		rand = randi() % 22 + 1
#		CreateCogu(Vector2(rand*64, y))
		y += 64

func _on_Timer_timeout():
	set_physics_process(true)

func NumCoguPlayerArea():
	var quanto = 0
	for i in Cogumelos:
		if i.global_position.y >= 896:
			quanto += 1
	return quanto

func SpawnAranha():
	if help.Aranha == false:
		randomize()
		var lado = randi() % 2
		if lado == 0:
			PositionAranha = SpawnEsqBaixo[randi() % len(SpawnEsqBaixo)].global_position
		if lado == 1:
			PositionAranha = SpawnDirBaixo[randi() % len(SpawnDirBaixo)].global_position
		$Node/TimerAranha.set_wait_time(randi() % 7 + 4)
		$Node/TimerAranha.start()
		help.Aranha = true

func SpawnConchinha():
	if help.CoguPlayerArea <= 5:
		if help.Conchinha == false:
			randomize()
			$Node/TimerConcha.set_wait_time(randi() % 10 + 6)
			$Node/TimerConcha.start()
			help.Conchinha = true


func get_morto():
	for i in range(len(cabecas)):
		if taVivo[i] == false:
			pass

func CreateCogu(posic):
	var mush = cogumelo.instance()
	$"Cogumelos".call_deferred('add_child', mush)
	mush.global_position = posic

func CreateAranha(posic):
	var spider = Aranha.instance()
	$Inimigos.call_deferred('add_child', spider)
	spider.global_position = posic
	if spider.global_position.x == -64:
		spider.dir = 1
	else:
		spider.dir = -1

func CreateConchinha():
	var pos = SpawnCima[randi() % len(SpawnCima)].global_position
	var Concha = ConchaObject.instance()
	$Inimigos.call_deferred('add_child', Concha)
	Concha.global_position = pos



func _on_TimerAranha_timeout():
	CreateAranha(PositionAranha)


func _on_TimerConcha_timeout():
	CreateConchinha()
