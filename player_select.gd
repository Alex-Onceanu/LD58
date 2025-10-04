extends Control

@export var clrName : String
@export var clr : Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background/Label.text = clrName
	$Background.color = clr
	$Background.color.a = 0.4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_player_toggled(toggled_on: bool) -> void:
	$AddPlayer.visible = false
	create_tween().tween_property($Background, "position", Vector2($Background.position.x, 130.), 0.7).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	$Background.visible = true
