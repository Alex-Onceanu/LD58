extends Node2D

const MARBLE_SCENE = preload("res://Scenes/Marble/physics_marble.tscn")
const SPAWN_POINT_SCENE = preload("res://Scenes/MainPhase/spawn_point.tscn")

var marbles_per_player : Dictionary # exemple : { 3 : [2, 2, 4, 5, 3], 1 : [1, 0, 0, 1, 2] }
var spawnPoints : Array # pos
var obstacles : Array # 4 instances d'obstacles
var who_plays := []
var last_spawn_selected
var level # TODO : level.tscn ici
var remainder
@onready var was_held := [false, false, false, false]
var curr_lvl

var held_obstacle

@onready var winner = null
@onready var whose_turn := 0

func _finished(body : Node2D):
	if not winner:
		winner = int(body.name.substr(body.name.length() - 1, 1))

func _ready():
	var l = level.instantiate()
	l.name = "level"
	$Level.add_child(l)
	for winArea in get_node("Level/level/WinAreas").get_children():
		winArea.body_entered.connect(_finished)
		
	for ch in get_node("Level/level/SpawnPoints").get_children():
		var nwsp = SPAWN_POINT_SCENE.instantiate()
		nwsp.global_position = ch.global_position
		$SpawnPoints.add_child(nwsp)

	for k in marbles_per_player.keys():
		for i in range(marbles_per_player[k].size()):
			var nw = MARBLE_SCENE.instantiate()
			nw.name = "Marble" + str(i) + str(k)
			nw.freeze = true
			nw.setTeam(k - 1)
			nw.visible = false
			nw.mass = marbles_per_player[k][i]
			nw.get_node("CollisionShape2D").scale = Vector2(marbles_per_player[k][i], marbles_per_player[k][i])
			nw.get_node("MarbleSprite").scale = Vector2(marbles_per_player[k][i], marbles_per_player[k][i])
			# nw.position = Vector2(150. + 300. * (k - 1), 500.)
			get_node("Marbles/" + str(k)).add_child(nw)

	for i in range(1, 5):
		var ob = obstacles[i - 1].instantiate()
		get_node("DraggableObstacle" + str(i) + "/Body").add_child(ob)
		get_node("DraggableObstacle" + str(i)).visible = true

	$WhoseTurn.text = ["Blue", "Red", "Yellow", "Green"][who_plays[0] - 1] + "'s turn to play"

func clicked_here(p : Vector2, whom):
	$Next.disabled = false
	if whose_turn >= who_plays.size() - 1:
		$Launch.disabled = false
	for ch in get_node("Marbles/" + str(who_plays[whose_turn])).get_children():
		ch.global_position = p + Vector2(randi_range(-10, 10), randi_range(-10, 10))
		ch.visible = true
		last_spawn_selected = whom

func _on_next_pressed() -> void:
	#last_spawn_selected.get_node("Area2D").visible = false
	whose_turn += 1
	$WhoseTurn.text = ["Blue", "Red", "Yellow", "Green"][who_plays[whose_turn] - 1] + "'s turn to play"
	if held_obstacle:
		held_obstacle.get_node("Area2D").visible = false
		was_held[int(held_obstacle.name.substr(held_obstacle.name.length() - 1, 1)) -1] = true
	held_obstacle = null
	$Next.disabled = true
	if whose_turn >= who_plays.size() - 1:
		$Next.visible = false
		$Launch.visible = true

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if held_obstacle and !event.pressed:
			held_obstacle.held = false

func _on_obstacle_picked(who):
	if held_obstacle and held_obstacle != who:
		held_obstacle.position = held_obstacle.reset_position
	held_obstacle = who
	who.pickup()

func _on_launch_pressed() -> void:
	if held_obstacle:
		was_held[int(held_obstacle.name.substr(held_obstacle.name.length() - 1, 1)) -1] = true
	for i in range(1, 5):
		get_node("DraggableObstacle" + str(i) + "/ColorRect").visible = false
		if not was_held[i - 1]:
			get_node("DraggableObstacle" + str(i)).free.call_deferred()
		for ch in get_node("Marbles/" + str(i)).get_children():
			ch.freeze = false
	$Next.visible = false
	$WhoseTurn.visible = false
	$Launch.visible = false

func _process(delta: float):
	var all_stables := true
	for i in range(1, 5):
		for ch in get_node("Marbles/" + str(i)).get_children():
			if not ch.stable:
				all_stables = false
	if all_stables:
		var MENU_SCENE = load("res://Scenes/Menus/selection_menu.tscn")
		var nw = MENU_SCENE.instantiate()

		var lose_per_player = {}
		if not winner:
			for k in marbles_per_player.keys():
				remainder[k].append_array(marbles_per_player[k])
		var tmp_who_plays = []
		for i in who_plays:
			if remainder[i].size() > 0 or i == winner:
				tmp_who_plays.append(i)
			if winner and i != winner:
				lose_per_player[i] = marbles_per_player[i]
		if winner:
			for i in marbles_per_player[winner]:
				remainder[winner].append(i)
		nw.memento_mori(tmp_who_plays, winner, lose_per_player, remainder, curr_lvl + 1)
		nw.name = "SelectionMenu"

		get_tree().root.add_child(nw)
		get_node("/root/TacticalPhase").free.call_deferred()
