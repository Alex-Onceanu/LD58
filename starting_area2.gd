extends Node2D

@export var selectedMarble = RigidBody2D;
@onready var myMarbles := [$PhysicsMarble]

func _process(_delta):
	if Input.is_action_just_pressed("mouse_click"):
		for m in myMarbles:
			#m.position = position
			$PhysicsMarble.global_transform.origin = position
			$PhysicsMarble.freeze = true
			
