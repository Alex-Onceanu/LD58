extends Node2D

@onready var t = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	t += delta
	$ColorRect.global_position.x = cos(t)
	$ColorRect.material.set("shader_parameter/gpos", $ColorRect.global_position)
