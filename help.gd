extends Node

onready var points : PackedScene = preload("res://Points.tscn")
var score : int = 0
var CanShoot : bool = true
var GerandoCabeca : bool = true
var Aranha : bool = false
var Conchinha : bool = false
var Cobrinha : bool = false
var CoguPlayerArea : int = 0

var vidaPlayer : int = 3


func DamagePlayer() -> void:
	vidaPlayer -= 1
	get_tree().reload_current_scene()
	if vidaPlayer == -1:
		vidaPlayer = 3
