extends Node2D

@export var force : float
@export var numberOfHits : int

func _ready():
	print(force)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("apply_impulse")):
		var normalVector = body.global_position - global_position

		body.linear_velocity = Vector2(0.0, 0.0)
		body.apply_impulse(force * 700 * (normalVector.normalized()))
		numberOfHits -= 1
		if (numberOfHits == 0):
			free.call_deferred()
