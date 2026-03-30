extends Node3D

@onready var pacman_viewport: SubViewport = $Room/ArcadeCabinet/PacManViewport
@onready var screen_mesh: MeshInstance3D = $Room/ArcadeCabinet/ScreenMesh

func _ready() -> void:
	# OpenXR initialisieren
	var xr_interface = XRServer.find_interface("OpenXR")
	if xr_interface and xr_interface.is_initialized():
		get_viewport().use_xr = true
		print("OpenXR aktiv")
	else:
		print("Kein VR gefunden – Desktop Fallback")
	
	# SubViewport Setup
	pacman_viewport.size = Vector2i(576, 324)
	pacman_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	# ViewportTexture auf Screen
	var mat = StandardMaterial3D.new()
	mat.albedo_texture = pacman_viewport.get_texture()
	mat.emission_enabled = true
	mat.emission_texture = pacman_viewport.get_texture()
	mat.emission_energy_multiplier = 0.8
	screen_mesh.material_override = mat
	
	# GameStateManager auf SubViewport zeigen
	GameStateManager.target_viewport = pacman_viewport
	
	# PacMan starten
	GameStateManager.updategamestate(1)
