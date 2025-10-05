extends StaticBody2D

@export var length: float
@export var height: float
@export var angular_velocity: float

func _ready() -> void:
	var polygon = [
		Vector2(-length/2, -height/2),
		Vector2(length/2, -height/2),
		Vector2(length/2, height/2),
		Vector2(-length/2, height/2)
	]
	$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon

func _process(delta: float) -> void:
	rotate(angular_velocity * delta)
