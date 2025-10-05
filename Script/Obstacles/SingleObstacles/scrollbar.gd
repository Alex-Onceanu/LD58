extends StaticBody2D

@export var vertical : bool
@export var range : float
@export var speed : float
var uptime : float
var baseX : float
var baseY : float

func _ready() -> void:
	uptime = 0
	baseX = position.x
	baseY = position.y
	if (!vertical):
		rotation_degrees = 90

func _process(delta: float) -> void:
	if (vertical):
		position.y = baseY + range * sin(uptime*speed)
	else:
		position.x = baseX + range * sin(uptime*speed)
	uptime += delta
	
