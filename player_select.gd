extends Node2D

@export var clrName : String
@export var clr : Color
@onready var held_object = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Label.text = clrName
	$Background/BackgroundImg.color = clr
	$Background/BackgroundImg.color.a = 0.4
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)

func _on_pickable_clicked(obj):
	if !held_object:
		obj.pickup()
		held_object = obj

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
			


func _on_add_player_pressed() -> void:
	$AddPlayer.visible = false
	$Background/RemovePlayer.visible = true
	$Marbles.visible = true
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, $Background.position.y-730.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	create_tween().tween_property($Marbles, "position", Vector2($Marbles.position.x, $Marbles.position.y-730.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_remove_player_pressed() -> void:
	$Background/RemovePlayer.visible = false
	$AddPlayer.visible = true
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, $Background.position.y+730), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	$Marbles.visible = false
	create_tween().tween_property($Marbles, "position", Vector2($Marbles.position.x, $Marbles.position.y+730.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	for i in range(1, 5):
		if get_node("Marbles/DraggableMarble" + str(i)).was_held:
			get_node("Marbles/DraggableMarble" + str(i)).reset_pos()
