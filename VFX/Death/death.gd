extends Node2D
class_name DEATHVFX
@onready var animations: AnimatedSprite2D =$AnimatedSprite2D
static func play_at(pos: Vector2) -> Node:
	var scene := preload("res://VFX/Death/death.tscn")
	var fx := scene.instantiate()
	fx.global_position = pos
	  # scène courante
	Engine.get_main_loop().current_scene .add_child(fx)
	return fx

func _ready():
	
	animations.play()
	animations.animation_finished.connect(queue_free)
