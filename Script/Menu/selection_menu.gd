extends Control

#const all_levels = ["res://Scenes/Levels/test_level.tscn"]
const all_levels = ["res://Scenes/Levels/level1.tscn", "res://Scenes/Levels/level2.tscn", "res://Scenes/Levels/level3.tscn", "res://Scenes/Levels/level4.tscn","res://Scenes/Levels/level5.tscn","res://Scenes/Levels/level6.tscn","res://Scenes/Levels/level7.tscn"]
const all_obstacles= ["BlackHole", "Bubble", "CircleCollide", "Funnel", "Ramp", "Scrollbar", "SpinningRectangle", "Teleporter", "TriangleSplit", "Windmill"]

const GAME_SCENE = preload("res://Scenes/MainPhase/tactical_phase.tscn")

@onready var started := false
@onready var who_bets := 0
@onready var nb_ready := 0

var curr_level

var who_plays := []

func _ready():
	get_parent().get_node("OSTBeats").volume_linear = 0.0
	get_parent().get_node("OST").volume_linear = 1.0
	if not curr_level:
		curr_level = 0

func _on_play_pressed() -> void:
	get_tree().root.get_node("Title/clic").play()
	for i in range(1, 5):
		if get_node("PlayerSelect" + str(i) + "/AddPlayer").visible == true:
			get_node("PlayerSelect" + str(i) + "/AddPlayer").visible = false
		else:
			who_plays.append(i)
		get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").visible = false
		#get_node("PlayerSelect" + str(i) + "/Background/Label").position.y = get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").position.y

	$WhoseTurn.text = get_node("PlayerSelect" + str(who_plays[0])).clrName + "'s turn to bet"
	$Next.visible = true
	$Play.visible = false
	get_node("PlayerSelect" + str(who_plays[0])).can_pick = true
	who_bets = 0
	var nw = GAME_SCENE.instantiate()
	nw.remainder = { 1 : [], 2 : [], 3 : [], 4 : [] }
	for i in who_plays:
		nw.marbles_per_player[i] = [1]
		nw.remainder[i] = [1, 1, 1, 1]
	nw.who_plays = who_plays
	nw.obstacles = [load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn"), load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn"), load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn"), load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn")]

	nw.level = load(all_levels.pick_random())
	nw.spawnPoints = [Vector2(150, 50), Vector2(433, 50), Vector2(725, 50), Vector2(1000, 50), Vector2(150, 150), Vector2(433, 150), Vector2(725, 150), Vector2(1000, 150)]
	nw.curr_lvl = curr_level

	get_tree().root.add_child(nw)
	get_node("/root/Title/SelectionMenu").free.call_deferred()

func _on_next_pressed() -> void:
	get_tree().root.get_node("Title/clic").play()
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = false
	who_bets += 1
	$Next.disabled = true
	$WhoseTurn.text = get_node("PlayerSelect" + str(who_plays[who_bets])).clrName + "'s turn to bet"
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = true
	if who_bets >= who_plays.size() - 1:
		$Next.visible = false
		$StartGame.visible = true

func _on_start_game_pressed() -> void:
	get_tree().root.get_node("Title/clic").play()
	get_node("PlayerSelect" + str(who_plays[who_bets])).can_pick = false
	who_bets = 0
	visible = false

	var nw = GAME_SCENE.instantiate()
	nw.level = load(all_levels.pick_random())

	get_node("../OSTBeats").volume_linear = 1.0
	get_node("../OST").volume_linear = 0.0

	nw.remainder = {}
	for i in who_plays:
		nw.marbles_per_player[i] = []
		nw.remainder[i] = []
		for ch in get_node("PlayerSelect" + str(i) + "/Marbles").get_children():
			if not ch.get_node("PhysicsMarble").freeze:
				nw.marbles_per_player[i].append(int(ch.get_node("PhysicsMarble").mass))
			else:
				nw.remainder[i].append(int(ch.get_node("PhysicsMarble").mass))
	nw.who_plays = who_plays
	nw.obstacles = [load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn"), load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn"), load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn"), load("res://Scenes/Obstacles/SingleObstacles/" + all_obstacles.pick_random() + ".tscn")]
	nw.curr_lvl = curr_level
	nw.spawnPoints = [Vector2(150, 50), Vector2(433, 50), Vector2(725, 50), Vector2(1000, 50), Vector2(150, 150), Vector2(433, 150), Vector2(725, 150), Vector2(1000, 150)]
	nw.name = "TacticalPhase"
	get_tree().root.add_child(nw)
	get_node("/root/Title/SelectionMenu").free.call_deferred()

func memento_mori(wp, winner, lose_per_player, remainder, curr_lvl):
	#print(wp, winner, lose_per_player, remainder)
	curr_level = curr_lvl
	who_plays = wp
	who_bets = 0
	for i in range(1, 5):
		if who_plays.has(i):
			get_node("PlayerSelect" + str(i) + "/AddPlayer").visible = false
			get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").visible = false
			#get_node("PlayerSelect" + str(i) + "/Background/Label").position.y = get_node("PlayerSelect" + str(i) + "/Background/RemovePlayer").position.y
			get_node("PlayerSelect" + str(i) + "/Background").position.y -= 730.
			get_node("PlayerSelect" + str(i) + "/Marbles").position.y -= 730.
			for m in get_node("PlayerSelect" + str(i) + "/Marbles").get_children():
				m.free.call_deferred()
		else:
			get_node("PlayerSelect" + str(i)).visible = false
	$WhoseTurn.text = get_node("PlayerSelect" + str(who_plays[0])).clrName + "'s turn to bet"
	$Next.visible = true
	$Play.visible = false
	get_node("PlayerSelect" + str(who_plays[0])).can_pick = true

	$Vide.visible = true
	$Vide2.visible = false
	$local.visible = false

	for k in remainder.keys():
		for sz in remainder[k]:
			var DRAG_MARB = load("res://Scenes/Marble/draggable_marble.tscn")
			var marb = DRAG_MARB.instantiate()
			marb.get_node("PhysicsMarble").setTeam(k - 1)
			marb.name = "DraggableMarble"
			get_node("PlayerSelect" + str(k) + "/Marbles").add_child(marb)
			marb.get_node("PhysicsMarble").mass = sz
			marb.get_node("PhysicsMarble/MarbleSprite").scale = Vector2(sz, sz)
			marb.get_node("PhysicsMarble/CollisionShape2D").scale = Vector2(sz, sz)
			marb.position = Vector2(randf_range(-50.0, 50.0), randf_range(650.0, 800.0))
	
	if wp.size() == 1:
		$Thx2/Label.text = ["Blue", "Red", "Yellow", "Green"][wp[0] - 1] + " won !!"
		$Thx2.visible = true
		$reboot.visible = true
		$Next.visible = false
		$StartGame.visible = false
		$Vide.visible = false
		$Vide2.visible = false
		$WhoseTurn.visible = false
		$local.visible = false
	
	if winner:
		for k in lose_per_player.keys():
			for sz in lose_per_player[k]:
				var DRAG_MARB = load("res://Scenes/Marble/draggable_marble.tscn")
				var marb = DRAG_MARB.instantiate()
				marb.get_node("PhysicsMarble").setTeam(winner - 1)
				marb.name = "DraggableMarble"
				get_node("PlayerSelect" + str(winner) + "/Marbles").add_child(marb)
				marb.get_node("PhysicsMarble").mass = sz
				marb.get_node("PhysicsMarble/MarbleSprite").scale = Vector2(sz, sz)
				marb.get_node("PhysicsMarble/CollisionShape2D").scale = Vector2(sz, sz)
				marb.global_position = get_node("PlayerSelect" + str(k)).global_position + Vector2(randf_range(-50.0, 50.0), randf_range(-150.0, 30.0))
				create_tween().tween_property(marb, 
					"global_position", 
						get_node("PlayerSelect" + str(winner)).global_position
						+ Vector2(randf_range(-50.0, 50.0), randf_range(-150.0, 30.0)), 2.0).set_trans(Tween.TRANS_SINE);


func _on_reboot_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainPhase/title.tscn")
