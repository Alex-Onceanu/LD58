extends Node2D

@onready var held = false
@onready var mouse_in = false
@onready var reset_position = position
@onready var was_held = false

var offset : Vector2

const PMARBLE_SCENE = preload("res://Scenes/Marble/physics_marble.tscn")

func _physics_process(delta):
	if held:
		global_position = get_global_mouse_position() + offset

func _process(delta):
	if Input.is_action_just_pressed("mouse_click") and mouse_in:
		if get_parent().get_parent().has_method("_on_obstacle_picked"):
			get_parent().get_parent()._on_obstacle_picked(self)
		else:
			get_parent()._on_obstacle_picked(self)
	elif not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		held = false

func pickup():
	was_held = true
	offset = global_position - get_global_mouse_position()
	if held:
		return
	held = true

func _on_area_2d_mouse_entered() -> void:
	mouse_in = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
