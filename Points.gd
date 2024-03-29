extends Position2D

onready var tween = $Tween

#const Aqua = Color(0, 1, 1, 1)
#const Red = Color(1,0,0,1)
#const Blue = Color(0,0,1,1)
const Yellow : Color = Color(1,1,0,1)
#const White = Color(1,1,1,1)
#const Purple = Color(1,0,1,1)
#const ListaCores = [Aqua,Red,Blue,Yellow,White,Purple]

var velocity : Vector2 = Vector2(50, -100)
const gravity : Vector2 = Vector2(0, 1)
var mass : float = 200

var text setget set_text, get_text
func _ready() -> void:
	if(global_position.x > 736):
		velocity = Vector2(-100, -100)
	else:
		velocity = Vector2(100, -100)
	$Label.modulate = Color(Yellow)
	tween.interpolate_property(self, "modulate",
		Color(modulate.r, modulate.g, modulate.b, modulate.a),
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)

	tween.interpolate_property(self, "scale",
		Vector2(0,0),
		Vector2(1.0, 1.0),
		0.3, Tween.TRANS_QUART, Tween.EASE_OUT)

	tween.interpolate_property(self, "scale",
		Vector2(1.0, 1.0),
		Vector2(0.4, 0.4),
		1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)

	#tween.interpolate_callback(self, 1.0, "destroy")

	tween.start()

func _process(delta) -> void:
	velocity += gravity * mass * delta
	position += velocity * delta

func set_text(new_text) -> void:
	$Label.text = str(new_text)

func get_text() -> String:
	return $Label.text


func _on_Timer_timeout() -> void:
	queue_free()
