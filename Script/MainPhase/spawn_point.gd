extends Node2D

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("mouse_click"):
		get_parent().get_parent().clicked_here(global_position, self)
