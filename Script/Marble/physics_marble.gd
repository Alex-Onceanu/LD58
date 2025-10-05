extends RigidBody2D

const WAIT_BEFORE_NEXT_ROUND = 2.0

@onready var stable := false
@onready var dt_sum := 0.0

@onready var old_pos = Vector2(0., 0.)

func setTeam(which : int) -> void:
	var clr = [Color(0.0, 0.0, 1.0, 1.0), 
				Color(1.0, 0.0, 0.0, 1.0), 
				Color(1.0, 1.0, 0.0, 1.0), 
				Color(0.0, 1.0, 0.0, 1.0)][which]

	$MarbleSprite/ColorRect.material.set("shader_parameter/team_color", clr)

func _physics_process(delta: float) -> void:
	if ((position - old_pos).length() < 0.01 or position.y > 800.) and not freeze :
		dt_sum += delta
	else:
		dt_sum = 0.0
	stable = dt_sum > WAIT_BEFORE_NEXT_ROUND
	old_pos = position
