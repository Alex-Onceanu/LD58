extends StaticBody2D

@export var fullSize: float
@export var branchWidth: float
@export var angular_velocity: float

func _ready() -> void:
	var polygon = [
		Vector2(-fullSize/2, -branchWidth/2),
		Vector2(-fullSize/2, branchWidth/2),
		Vector2(-branchWidth/2, branchWidth/2),
		Vector2(-branchWidth/2, fullSize/2),
		Vector2(branchWidth/2, fullSize/2),
		Vector2(branchWidth/2, branchWidth/2),
		Vector2(fullSize/2, branchWidth/2),
		Vector2(fullSize/2, -branchWidth/2),
		Vector2(branchWidth/2, -branchWidth/2),
		Vector2(branchWidth/2, -fullSize/2),
		Vector2(-branchWidth/2, -fullSize/2),
		Vector2(-branchWidth/2, -branchWidth/2),
	]
	#$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon

func _process(delta: float) -> void:
	rotate(angular_velocity * delta)
