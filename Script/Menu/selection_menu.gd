extends Control

@onready var started := false
@onready var who_bets := 0
@onready var nb_ready := 0

var who_plays := []

func _on_play_pressed() -> void:
	for i in range(1, 5):
		if get_node("PlayerSelect" + str(i) + "/AddPlayer").visible == true:
			get_node("PlayerSelect" + str(i) + "/AddPlayer").visible = false
		else:
			who_plays.append(i)
		get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").visible = false
		get_node("PlayerSelect" + str(i) + "/Background/Label").position.y = get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").position.y

	$Next.visible = true
	$Play.visible = false
	get_node("PlayerSelect" + str(who_plays[0])).can_pick = true
	who_bets = 0
	print(who_plays)

	#resize les menus ici ?
	#get_node("PlayerSelect" + str(i) + "/Background").scale = 
	#visible = false


func _on_next_pressed() -> void:
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = false
	who_bets += 1
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = true
	if who_bets >= who_plays.size() - 1:
		$Next.visible = false
		$StartGame.visible = true

func _on_start_game_pressed() -> void:
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = false
	who_bets = 0
	visible = false
	#passer au jeu
