extends Node2D

@export var st : Node2D
@export var marbles : Node2D
@export var obstacles : Node2D

func _ready():
	var current = $marbles/Marble
	changeActiveMarble(current)
	
func changeActiveMarble(marble):
	print(marble)
	for N in $startingAreas.get_children():
		print(N)
		N.selectedMarble = marble
	
