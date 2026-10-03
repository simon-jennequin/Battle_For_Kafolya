extends Sprite2D


@onready var camera 
@onready var viewport := get_viewport()
@onready var cursor: Sprite2D = $"."

const CURSOR_B = preload("res://HUD/Cursor/cursor_b.png")
const CURSOR_J = preload("res://HUD/Cursor/cursor_j.png")
const CURSOR_R = preload("res://HUD/Cursor/cursor_r.png")
const CURSOR_V = preload("res://HUD/Cursor/cursor_v.png")
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	
func init(game,couleur):
	game.add_child(self)
	camera = game.new_camera
	match couleur:
		"red":
			cursor.texture = CURSOR_R
		"green":
			cursor.texture = CURSOR_V
		"yellow":
			cursor.texture = CURSOR_J
		"blue":
			cursor.texture = CURSOR_B
func _process(delta: float) -> void:
	
	# Position souris en monde
	if camera==null:return
	
	var mouse_world := get_global_mouse_position()

	# Rect visible par la caméra
	var screen_rect := Rect2(
	camera.get_screen_center_position() - (Vector2(viewport.size) / 2) / camera.zoom,
	Vector2(viewport.size) / camera.zoom
)

	# Clamp la souris à ce rect
	var clamped_mouse := mouse_world.clamp(screen_rect.position, screen_rect.position + screen_rect.size)
	global_position = clamped_mouse
