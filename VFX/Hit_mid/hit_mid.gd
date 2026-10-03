extends Node2D
class_name HITMIDVFX
@onready var animations: AnimatedSprite2D =$AnimatedSprite2D
static func play_at(pos: Vector2) -> Node:
	const scene = preload("res://VFX/Hit_low/hit_low.tscn")
	var fx := scene.instantiate()
	fx.global_position = pos
	  # scène courante
	Engine.get_main_loop().current_scene .add_child(fx)
	return fx

# --- 2) Cycle de vie de l'effet ---
func _ready():
	
	animations.play()
	animations.animation_finished.connect(queue_free)
