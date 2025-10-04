extends Node2D

signal clicked

@onready var held = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(self)

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()

func pickup():
	if held:
		return
	#$PhysicsMarble.freeze = true
	#$PhysicsMarble.apply_central_impulse(impulse)
	held = true
	
func drop(impulse=Vector2.ZERO):
	if held:
		#$PhysicsMarble.freeze = false
		#$PhysicsMarble.apply_central_impulse(impulse)
		held = false
