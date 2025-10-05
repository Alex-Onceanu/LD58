extends Node2D

@export var length: float
@export var height: float
@export var spacingX: float
@export var spacingY: float
var spacing: Vector2

func _ready() -> void:
	spacing = Vector2(spacingX, spacingY)
	var polygon = [
		Vector2(-length/2, -height/2),
		Vector2(length/2, -height/2),
		Vector2(length/2, height/2),
		Vector2(-length/2, height/2)
	]
	$Entry/Polygon2D.polygon = polygon
	$Entry/Area2D/CollisionPolygon2D.polygon = polygon
	$Exit.polygon = polygon
	$Exit.position = $Entry.position + spacing

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("apply_impulse")):
		body.global_position += spacing
