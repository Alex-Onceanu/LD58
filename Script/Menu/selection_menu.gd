extends Control

const GAME_SCENE = preload("res://Scenes/MainPhase/tactical_phase.tscn")

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

	$WhoseTurn.text = get_node("PlayerSelect" + str(who_plays[0])).clrName + "'s turn to bet"
	$Next.visible = true
	$Play.visible = false
	get_node("PlayerSelect" + str(who_plays[0])).can_pick = true
	who_bets = 0
	var nw = GAME_SCENE.instantiate()
	for i in who_plays:
		nw.marbles_per_player[i] = [1]
		#for ch in get_node("PlayerSelect" + str(i) + "/Marbles").get_children():
			#if not ch.freeze:
				#nw.marbles_per_player[i].append(1) # TODO : append le bon skin
	nw.who_plays = who_plays
	nw.obstacles = [preload("res://Scenes/Obstacles/slope2.tscn"), preload("res://Scenes/Obstacles/slope2.tscn"), preload("res://Scenes/Obstacles/physics_obstacle.tscn"), preload("res://Scenes/Obstacles/physics_obstacle2.tscn")]

	# TODO : lire le level et supprimer .spawnPoints car contenu dans level
	nw.level = null
	nw.spawnPoints = [Vector2(150, 50), Vector2(433, 50), Vector2(725, 50), Vector2(1000, 50), Vector2(150, 150), Vector2(433, 150), Vector2(725, 150), Vector2(1000, 150)]
	
	get_tree().root.add_child(nw)
	get_node("/root/SelectionMenu").free.call_deferred()

func _on_next_pressed() -> void:
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = false
	who_bets += 1
	$WhoseTurn.text = get_node("PlayerSelect" + str(who_plays[who_bets])).clrName + "'s turn to bet"
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = true
	if who_bets >= who_plays.size() - 1:
		$Next.visible = false
		$StartGame.visible = true

func _on_start_game_pressed() -> void:
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = false
	who_bets = 0
	visible = false

	var nw = GAME_SCENE.instantiate()
	for i in who_plays:
		nw.marbles_per_player[i] = []
		for ch in get_node("PlayerSelect" + str(i) + "/Marbles").get_children():
			if not ch.get_node("PhysicsMarble").freeze:
				nw.marbles_per_player[i].append(1) # TODO : append le bon skin
	nw.who_plays = who_plays
	nw.obstacles = [preload("res://Scenes/Obstacles/slope2.tscn"), preload("res://Scenes/Obstacles/slope2.tscn"), preload("res://Scenes/Obstacles/physics_obstacle.tscn"), preload("res://Scenes/Obstacles/physics_obstacle2.tscn")]

	# TODO : lire le level et supprimer .spawnPoints car contenu dans level
	nw.level = null
	nw.spawnPoints = [Vector2(150, 50), Vector2(433, 50), Vector2(725, 50), Vector2(1000, 50), Vector2(150, 150), Vector2(433, 150), Vector2(725, 150), Vector2(1000, 150)]
	
	get_tree().root.add_child(nw)
	get_node("/root/SelectionMenu").free.call_deferred()

func memento_mori(wp, bet_per_player, winner):
	who_plays = wp
	who_bets = 0
	for i in range(1, 5):
		if who_plays.has(i):
			get_node("PlayerSelect" + str(i) + "/AddPlayer").visible = false
			get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").visible = false
			get_node("PlayerSelect" + str(i) + "/Background/Label").position.y = get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").position.y
			get_node("PlayerSelect" + str(i) + "/Background").position.y -= 730.
			get_node("PlayerSelect" + str(i) + "/Marbles").position.y -= 730.
		else:
			get_node("PlayerSelect" + str(i)).visible = false
	$WhoseTurn.text = get_node("PlayerSelect" + str(who_plays[0])).clrName + "'s turn to bet"
	$Next.visible = true
	$Play.visible = false
	get_node("PlayerSelect" + str(who_plays[0])).can_pick = true
	
	# TODO : charger les bons marbles au lieu de faire au pif
	
	for k in bet_per_player.keys():
		if k != winner:
			for j in range(1, 1 + min(4, bet_per_player[k].size())):
				var a = get_node("PlayerSelect" + str(k) + "/Marbles/DraggableMarble1/PhysicsMarble")
				a.freeze = true
				var tw = create_tween()
				tw.tween_property(get_node("PlayerSelect" + str(k) + "/Marbles/DraggableMarble1"), 
					"global_position", 
					get_node("PlayerSelect" + str(winner)).global_position 
						+ Vector2(randf_range(-20.0, 20.0), randf_range(-100.0, 100.0)), 2.0).set_trans(Tween.TRANS_SINE);

				# TODO : comment faire en sorte qu'il appartienne au bon PlayerSelect ? 
				#tw.tween_callback().set_delay(2.0)

				get_node("PlayerSelect" + str(k) + "/Marbles/DraggableMarble1/PhysicsMarble").setTeam(winner - 1)
