extends Node2D

@onready var held = false
@onready var mouse_in = false

@onready var was_held = false
var pos_to_reset : Vector2
@onready var should_reset = false

const PMARBLE_SCENE = preload("res://Scenes/Marble/physics_marble.tscn")

func _ready() -> void:
	$PhysicsMarble.freeze = true
	pos_to_reset = $PhysicsMarble.global_transform.origin

func _physics_process(delta):
	if held:
		$PhysicsMarble.global_transform.origin = get_global_mouse_position()
	if should_reset:
		print(pos_to_reset, $PhysicsMarble.global_transform.origin)
		$PhysicsMarble.global_transform.origin = pos_to_reset
		$PhysicsMarble.freeze = false
		should_reset = false

func _process(delta):
	if Input.is_action_just_pressed("mouse_click") and mouse_in:
		get_parent().get_parent()._on_pickable_clicked(self)
	elif not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		held = false

func pickup():
	was_held = true
	if held:
		return
	$PhysicsMarble.freeze = true
	held = true
	
func drop(impulse=Vector2.ZERO):
	if held:
		$PhysicsMarble.freeze = false
		$PhysicsMarble.apply_central_impulse(impulse)
		held = false


func _on_area_2d_mouse_entered() -> void:
	mouse_in = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in = false
