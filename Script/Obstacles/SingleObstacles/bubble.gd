extends Node2D

@export var force : float
@export var numberOfHits : int

	
func pop(body):
	var normalVector = body.global_position - global_position

	body.linear_velocity = Vector2(0.0, 0.0)
	body.apply_impulse(force * 700 * (normalVector.normalized()))
	numberOfHits -= 1
	if (numberOfHits == 0):
		free.call_deferred()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("apply_impulse")):
		get_tree().create_tween().tween_callback(pop.bind(body)).set_delay(0.05)
		get_tree().create_tween().tween_property($Sprite2D, "scale", Vector2(0.3, 0.3), 0.05).set_trans(Tween.TRANS_QUINT)
