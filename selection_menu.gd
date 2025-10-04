extends Control

var held_object = null

func _ready():
	for node in get_tree().get_nodes_in_group("pickable"):
		node.clicked.connect(_on_pickable_clicked)

func _on_pickable_clicked(obj):
	if !held_object:
		obj.pickup()
		held_object = obj

func _on_start_pressed() -> void:
	for i in range(1, 5):
		if get_node("PlayerSelect" + str(i) + "/AddPlayer").visible == true:
			get_node("PlayerSelect" + str(i) + "/AddPlayer").visible = false
		get_node("PlayerSelect" + str(i) + "/RemovePlayer").visible = false
		get_node("PlayerSelect" + str(i) + "/AddPlayer").position = get_node("PlayerSelect" + str(i) + "/RemovePlayer").position
		#resize les menus ici ?
		#get_node("PlayerSelect" + str(i) + "/Background").scale = 
	#visible = false
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_velocity())
			held_object = null
