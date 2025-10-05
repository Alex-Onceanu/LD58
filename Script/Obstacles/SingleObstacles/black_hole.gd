extends Node2D

@onready var attractedMarbles : Array = []
@export var forceFactor : float

func _process(delta: float) -> void:
	for marble in attractedMarbles:
		var distance = global_position - marble.global_position
		var direction = distance.normalized()
		var impulse = forceFactor * 10e8 / (distance.length()*distance.length())
		marble.apply_force(delta * impulse * direction)

func _on_attracteur_body_entered(body: Node2D) -> void:
	if (body.has_method("apply_impulse")):
		attractedMarbles.append(body)

func _on_attracteur_body_exited(body: Node2D) -> void:
	if (body.has_method("apply_impulse")):
		attractedMarbles.erase(body)
