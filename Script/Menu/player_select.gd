extends Node2D

@export var clrName : String
@export var clr : Color

@onready var held_object = null
var can_pick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Label.text = clrName
	$Background/BackgroundImg.color = clr
	$Background/BackgroundImg.color.a = 0.4
	
	for ch in $Marbles.get_children():
		ch.get_node("PhysicsMarble/MarbleSprite/ColorRect").material.set("shader_parameter/team_color", clr)

func _on_pickable_clicked(obj):
	if !held_object and can_pick:
		get_parent().get_node("Next").disabled = false
		if get_parent().who_bets >= get_parent().who_plays.size() - 1:
			get_parent().get_node("StartGame").disabled = false
		obj.pickup()
		held_object = obj
		
func merge(toDestroy, toGrow):
	toDestroy.free.call_deferred()
	toGrow.get_node("PhysicsMarble").mass *= 2
	toGrow.get_node("PhysicsMarble/MarbleSprite").scale *= 2
	toGrow.get_node("PhysicsMarble/CollisionShape2D").scale *= 2

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			var merged := false
			for m in $Marbles.get_children():
				if m != held_object and m.mouse_in and int(m.get_node("PhysicsMarble").mass) == int(held_object.get_node("PhysicsMarble").mass):
					merge(held_object, m)
					merged = true
					break
			if not merged:
				held_object.drop(Input.get_last_mouse_velocity())
			held_object = null

func _on_add_player_pressed() -> void:
	$AddPlayer.visible = false
	$Background/RemovePlayer.visible = true
	$Marbles.visible = true
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, $Background.position.y-730.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	create_tween().tween_property($Marbles, "position", Vector2($Marbles.position.x, $Marbles.position.y-730.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	get_parent().nb_ready += 1
	if get_parent().nb_ready > 1:
		get_node("../Play").disabled = false

func _on_remove_player_pressed() -> void:
	$Background/RemovePlayer.visible = false
	$AddPlayer.visible = true
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, $Background.position.y+730), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	$Marbles.visible = false
	create_tween().tween_property($Marbles, "position", Vector2($Marbles.position.x, $Marbles.position.y+730.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	get_parent().nb_ready -= 1
	if get_parent().nb_ready <= 1:
		get_node("../Play").disabled = true
