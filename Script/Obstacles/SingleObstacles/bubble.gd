extends Node2D

@export var force : float
@export var numberOfHits : int

var stop = false
var t = 0
	
func pop(body):
	var normalVector = body.global_position - global_position

	body.linear_velocity = Vector2(0.0, 0.0)
	body.apply_impulse(force * 700 * (normalVector.normalized()))
	numberOfHits -= 1
	if (numberOfHits == 0):
		free.call_deferred()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("apply_impulse") and not body.freeze):
		get_tree().create_tween().tween_callback(pop.bind(body)).set_delay(0.05)
		$Sprite2D.scale = Vector2(0.15, 0.15)
		get_tree().create_tween().tween_property($Sprite2D, "scale", Vector2(0.3, 0.3), 0.05).set_trans(Tween.TRANS_QUINT)
		stop = true

func _process(delta: float) -> void:
	t += delta
	if not stop:
		var f = lerp(0.125, 0.175, 0.5 + 0.5 * sin(t))
		$Sprite2D.scale = Vector2(f, f)
