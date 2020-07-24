extends Node2D
#1440 direita
#-32 esquerda
var only : bool = true
var cabecas : Array
var taVivo : Array = [0, 0, 0, 0, 0, 0, 0, 0, 0]
onready var SpawnCima : Array = $Spawns/Topo.get_children()
onready var SpawnDirTopo : Array = $Spawns/DireitaTopo.get_children()
onready var SpawnDirBaixo : Array = $Spawns/DireitaBaixo.get_children()
onready var SpawnEsqTopo : Array = $Spawns/EsquerdaTopo.get_children()
onready var SpawnEsqBaixo : Array = $Spawns/EsquerdaBaixo.get_children()
var Cogumelos : Array

onready var cogumelo : PackedScene = preload("res://Cogumelo.tscn")
onready var Aranha : PackedScene = preload("res://Aranha.tscn")
onready var ConchaObject : PackedScene	 = preload("res://conchinha.tscn")

var PositionAranha : Vector2 = Vector2.ZERO
var PositionConchinha : Vector2 = Vector2.ZERO

#18 blocos de altura
#22 blocos de comprimento

func _ready():
	$Node/TimerConcha.start()
	$Node/TimerAranha.start()
	setMap()
	set_physics_process(false)

func _process(_delta) -> void:
	$Control/Panel/FPS.text = str(Performance.get_monitor(Performance.TIME_FPS))
	score()
	Cogumelos = $Cogumelos.get_children()
	help.CoguPlayerArea = NumCoguPlayerArea()
	SpawnAranha()
	SpawnConchinha()
	cabecas = $Cabecas.get_children()
	if Input.is_action_just_pressed("click"):
		CreateCogu(Vector2(get_global_mouse_position().x - 32, get_global_mouse_position().y - 32))


func score() -> void:
	$Control/Panel/Pontuacao.set_text(String(help.score))

func setMap() -> void:
	var y : int = 32+64
	var rand : int
	var oneOrTwo : int
	for _i in range(16):
		oneOrTwo = randi() % 2+1
		for _j in range(oneOrTwo):
			rand = randi() % 21 + 1
			CreateCogu(Vector2(rand*64+32, y))
#		randomize()
#		rand = randi() % 22 + 1
#		CreateCogu(Vector2(rand*64, y))
		y += 64

func _on_Timer_timeout() -> void:
	set_physics_process(true)

func NumCoguPlayerArea() -> int:
	var quanto : int = 0
	for i in Cogumelos:
		if i.global_position.y >= 896:
			quanto += 1
	return quanto

func SpawnAranha() -> void:
	if help.Aranha == false:
		var lado : int = randi() % 2
		if lado == 0:
			PositionAranha = SpawnEsqBaixo[randi() % len(SpawnEsqBaixo)].global_position
		if lado == 1:
			PositionAranha = SpawnDirBaixo[randi() % len(SpawnDirBaixo)].global_position
		$Node/TimerAranha.set_wait_time(randi() % 7 + 4)
		$Node/TimerAranha.start()
		help.Aranha = true

func SpawnConchinha() -> void:
	if help.CoguPlayerArea <= 5:
		if help.Conchinha == false:
			$Node/TimerConcha.set_wait_time(randi() % 10 + 6)
			$Node/TimerConcha.start()
			help.Conchinha = true


func get_morto() -> void:
	for i in range(len(cabecas)):
		if taVivo[i] == false:
			pass

func CreateCogu(posic) -> void:
	var mush : Node = cogumelo.instance()
	$"Cogumelos".call_deferred('add_child', mush)
	mush.global_position = posic

func CreateAranha(posic) -> void:
	var spider : Node = Aranha.instance()
	$Inimigos.call_deferred('add_child', spider)
	spider.global_position = posic
	if spider.global_position.x == -64:
		spider.dir = 1
	else:
		spider.dir = -1

func CreateConchinha() -> void:
	var pos : Vector2 = SpawnCima[randi() % len(SpawnCima)].global_position
	var Concha : Node = ConchaObject.instance()
	$Inimigos.call_deferred('add_child', Concha)
	Concha.global_position = pos



func _on_TimerAranha_timeout() -> void:
	CreateAranha(PositionAranha)


func _on_TimerConcha_timeout() -> void:
	CreateConchinha()
