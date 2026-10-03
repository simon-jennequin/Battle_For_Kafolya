extends AnimatedSprite2D
class_name JUMPVFX
@onready var animations: AnimatedSprite2D = $"."
static func play_at(pos: Vector2) -> Node:
	var scene := preload("res://VFX/Jump/jumpvfx.tscn")
	var fx := scene.instantiate()
	fx.global_position = pos
	  # scène courante
	Engine.get_main_loop().current_scene .add_child(fx)
	return fx

# --- 2) Cycle de vie de l'effet ---
func _ready():
	
	animations.play()
	animations.animation_finished.connect(queue_free)
	
