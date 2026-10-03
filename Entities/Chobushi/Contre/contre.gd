extends Node
class_name COUNTER
@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Area2D

var own
static func create(perso):
	var inst = preload("res://Entities/Chobushi/Contre/contre.tscn").instantiate()
	inst.own = perso
	
	
	
	
	Engine.get_main_loop().current_scene.add_child(inst)
	inst.global_position = perso.global_position
	inst.animations.flip_h = perso.animation.flip_h
	
	return inst
func _process(_delta: float) -> void:
	
	if animations.frame<1:
		hitbox.activate(own)
	else:
		hitbox.desactivate()
	if not animations.is_playing():
		destroy()
	
func destroy():
	hitbox.desactivate()
	queue_free()

# Replace with function body.
