extends Node2D

const MARBLE_SCENE = preload("res://Scenes/Marble/physics_marble.tscn")
const SPAWN_POINT_SCENE = preload("res://Scenes/MainPhase/spawn_point.tscn")

var marbles_per_player : Dictionary # exemple : { 3 : [2, 2, 4, 5, 3], 1 : [1, 0, 0, 1, 2] }
var spawnPoints : Array # pos
var obstacles : Array # 4 instances d'obstacles
var who_plays := []
var last_spawn_selected
var level # TODO : level.tscn ici

var held_obstacle

@onready var whose_turn := 0

func _ready():
	if level:
		var l = level.instantiate()
		l.name = "level"
		$Level.add_child(l)

	for sp in spawnPoints: # for ch in $Level/level/SpawnPoints.get_children() ...... sp = ch.global_position
		var nwsp = SPAWN_POINT_SCENE.instantiate()
		nwsp.global_position = sp
		$SpawnPoints.add_child(nwsp)

	for k in marbles_per_player.keys():
		for i in range(marbles_per_player[k].size()):
			var nw = MARBLE_SCENE.instantiate()
			nw.name = "Marble" + str(i)
			nw.freeze = true
			nw.setTeam(k - 1)
			nw.visible = false
			# nw.position = Vector2(150. + 300. * (k - 1), 500.)
			get_node("Marbles/" + str(k)).add_child(nw)

	for i in range(1, 5): # in who_plays si jamais
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
	last_spawn_selected.get_node("Area2D").visible = false
	whose_turn += 1
	$WhoseTurn.text = ["Blue", "Red", "Yellow", "Green"][who_plays[whose_turn] - 1] + "'s turn to play"
	if held_obstacle:
		held_obstacle.get_node("Area2D").visible = false
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
	for i in range(1, 5):
		get_node("DraggableObstacle" + str(i) + "/ColorRect").visible = false
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

		# TODO : trier who_plays par ordre de distance au drapeau / survie / ??
		nw.memento_mori(who_plays, marbles_per_player, 2)
		nw.name = "SelectionMenu"

		get_tree().root.add_child(nw)
		get_node("/root/TacticalPhase").free.call_deferred()
