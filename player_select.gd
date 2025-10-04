extends Control

@export var clrName : String
@export var clr : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Label.text = clrName
	$Background.color = clr
	$Background.color.a = 0.4

func _on_add_player_pressed() -> void:
	$AddPlayer.visible = false
	$Background/RemovePlayer.visible = true
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, -30.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _on_remove_player_pressed() -> void:
	$Background/RemovePlayer.visible = false
	$AddPlayer.visible = true
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, 800.), 0.5).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
