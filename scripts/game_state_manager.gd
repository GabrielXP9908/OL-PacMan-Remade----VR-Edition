extends Node

var gamestate := 0
var target_viewport: SubViewport = null  # wird vom VR-Projekt gesetzt

signal gamestateupdated(new_gamestate_id: int)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func new_gamestate(new_gamestate_id: int) -> void:
	# VR Modus – in SubViewport wechseln
	if target_viewport != null:
		for child in target_viewport.get_children():
			child.queue_free()
		# kurz warten bis queue_free durch ist
		await get_tree().process_frame
		
		var scene_path: String
		if new_gamestate_id == 0:
			scene_path = "res://scenes/title_screen.tscn"
		elif new_gamestate_id == 1:
			scene_path = "res://scenes/Leaderboard.tscn"
		elif new_gamestate_id == 2:
			scene_path = "res://scenes/level.tscn"
			GameManager.score = 0
		
		target_viewport.add_child(load(scene_path).instantiate())
		gamestateupdated.emit(new_gamestate_id)
		return
	
	# Fallback – normaler Desktop Modus (PacMan standalone)
	if new_gamestate_id == 0:
		get_tree().change_scene_to_file("res://pacman/scenes/title_screen.tscn")
	elif new_gamestate_id == 1:
		get_tree().change_scene_to_file("res://pacman/scenes/Leaderboard.tscn")
	elif new_gamestate_id == 2:
		get_tree().change_scene_to_file("res://pacman/scenes/level.tscn")
		GameManager.score = 0
	gamestateupdated.emit(gamestate)

func getGamestate() -> int:
	return gamestate

func updategamestate(new_gamestate_id: int) -> void:
	print("Gamestate: %d → %d" % [gamestate, new_gamestate_id])
	gamestate = new_gamestate_id
	new_gamestate(gamestate)
