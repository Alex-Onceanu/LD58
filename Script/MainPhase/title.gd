extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StartupSound.play()
	$clic.volume_linear = 0.6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$OST.play()
	$OSTBeats.play()
	$TitleLayer.visible = false
	$clic.play()


func _on_ost_finished() -> void:
	$OST.stop()
	$OSTBeats.stop()

	$OST.play()
	$OSTBeats.play()
