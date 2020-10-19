extends Node2D
#1440 direita
#-32 esquerda
var only : bool = true
var cabecas : Array
var taVivo : Array = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var vidasPlayer : int = 3
onready var SpawnCima : Array = $Spawns/Topo.get_children()
onready var SpawnDirTopo : Array = $Spawns/DireitaTopo.get_children()
onready var SpawnDirBaixo : Array = $Spawns/DireitaBaixo.get_children()
onready var SpawnEsqTopo : Array = $Spawns/EsquerdaTopo.get_children()
onready var SpawnEsqBaixo : Array = $Spawns/EsquerdaBaixo.get_children()
var Cogumelos : Array

onready var cogumelo : PackedScene = preload("res://Cogumelo.tscn")
onready var Aranha : PackedScene = preload("res://Aranha.tscn")
onready var ConchaObject : PackedScene = preload("res://conchinha.tscn")
onready var CobrinhaObject : PackedScene = preload("res://Cobrinha.tscn")
onready var ExtraCentipede : PackedScene = preload("res://ExtraCentipede.tscn")

var PositionAranha : Vector2 = Vector2.ZERO
var PositionConchinha : Vector2 = Vector2.ZERO
var PositionCobrinha : Vector2 = Vector2.ZERO


var MadnessTime : bool = false

#18 blocos de altura
#22 blocos de comprimento

func _ready():
	$Node/TimerConcha.start()
	$Node/TimerAranha.start()
	setMap()
	set_physics_process(false)

func _process(_delta) -> void:
	$Control/Panel/FPS.text = str(MadnessTime)#Performance.get_monitor(Performance.TIME_FPS))
	if help.vidaPlayer == 3:
		$Control/Panel/Control/Sprite3.visible = true
		$Control/Panel/Control/Sprite2.visible = true
		$Control/Panel/Control/Sprite1.visible = true
	elif help.vidaPlayer == 2:
		$Control/Panel/Control/Sprite3.visible = false
		$Control/Panel/Control/Sprite2.visible = true
		$Control/Panel/Control/Sprite1.visible = true
	elif help.vidaPlayer == 1:
		$Control/Panel/Control/Sprite3.visible = false
		$Control/Panel/Control/Sprite2.visible = false
		$Control/Panel/Control/Sprite1.visible = true
	elif help.vidaPlayer == 0:
		$Control/Panel/Control/Sprite3.visible = false
		$Control/Panel/Control/Sprite2.visible = false
		$Control/Panel/Control/Sprite1.visible = false
	score()
	Cogumelos = $Cogumelos.get_children()
	help.CoguPlayerArea = NumCoguPlayerArea()
	SpawnAranha()
	SpawnConchinha()
	SpawnCobrinha()
	cabecas = $Cabecas.get_children()


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
		elif lado == 1:
			PositionAranha = SpawnDirBaixo[randi() % len(SpawnDirBaixo)].global_position
		$Node/TimerAranha.set_wait_time(randi() % 7 + 4)
		$Node/TimerAranha.start()
		help.Aranha = true

func SpawnCobrinha() -> void:
	if help.Cobrinha == false:
		var lado : int = randi() % 2
		if lado == 0:
			PositionCobrinha = SpawnEsqTopo[randi() % len(SpawnEsqTopo)].global_position
		elif lado == 1:
			PositionCobrinha = SpawnDirTopo[randi() % len(SpawnDirTopo)].global_position
		$Node/TimerCobra.set_wait_time(randi() % 8 + 5)
		$Node/TimerCobra.start()
		help.Cobrinha = true

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

func CreateCobrinha(pos : Vector2) -> void:
	var cobrinha : Node = CobrinhaObject.instance()
	$Inimigos.call_deferred('add_child', cobrinha)
	cobrinha.global_position = pos

func CreateCabecaExtra(pos : Vector2) -> void:
	var ECenti : Node = ExtraCentipede.instance()
	$CabecasExtras.call_deferred('add_child', ECenti)
	ECenti.global_position = pos


func _on_TimerAranha_timeout() -> void:
	CreateAranha(PositionAranha)


func _on_TimerConcha_timeout() -> void:
	CreateConchinha()


func _on_TimerCobra_timeout():
	CreateCobrinha(PositionCobrinha)


func _on_TimerCabecaExtra_timeout():
	if MadnessTime and $CabecasExtras.get_child_count() < 10:
		var spots : Array = [$Spawns/EsquerdaBaixo/Position2D14, $Spawns/DireitaBaixo/Position2D14]
		CreateCabecaExtra(spots[randi() % 2].global_position)
