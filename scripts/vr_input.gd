extends Node3D

@onready var pacman_viewport: SubViewport = get_node("/root/Main/Room/ArcadeCabinet/PacManViewport")
@onready var right_controller: XRController3D = get_node("/root/Main/XROrigin3D/RightController")

var last_stick := Vector2.ZERO
var stick_threshold := 0.5

func _process(_delta: float) -> void:
	var stick: Vector2 = right_controller.get_vector2("primary")
	
	# Nur bei frischer Eingabe senden (kein Dauerfeuern)
	if stick.length() > stick_threshold and last_stick.length() <= stick_threshold:
		if abs(stick.x) > abs(stick.y):
			_push_action("right" if stick.x > 0 else "left")
		else:
			_push_action("up" if stick.y < 0 else "down")
	
	last_stick = stick
	
	# Start Button (A/Cross) → play action
	if right_controller.is_button_pressed("ax_button"):
		_push_action("play")

func _push_action(action: String) -> void:
	var event := InputEventAction.new()
	event.action = action
	event.pressed = true
	pacman_viewport.push_input(event)
	
	# Release gleich danach
	await get_tree().process_frame
	var release := InputEventAction.new()
	release.action = action
	release.pressed = false
	pacman_viewport.push_input(release)
