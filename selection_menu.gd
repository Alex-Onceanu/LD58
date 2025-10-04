extends Control

func _on_start_pressed() -> void:
	for i in range(1, 5):
		if get_node("PlayerSelect" + str(i) + "/AddPlayer").visible == true:
			get_node("PlayerSelect" + str(i) + "/AddPlayer").visible = false
		get_node("PlayerSelect" + str(i) + "/RemovePlayer").visible = false
		get_node("PlayerSelect" + str(i) + "/AddPlayer").position = get_node("PlayerSelect" + str(i) + "/RemovePlayer").position
		#resize les menus ici ?
		#get_node("PlayerSelect" + str(i) + "/Background").scale = 
	#visible = false
