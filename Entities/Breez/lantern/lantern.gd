extends Node2D
var own
var state = 0
@onready var animation: AnimatedSprite2D = $"."
@export var idle_pos:Marker2D
func _ready() -> void:
	own = $".."

	own.attack.connect(func():go_state1())
	animation.modulate = own.c
func _process(_delta: float) -> void:
	if own.is_aim:global_position = own.global_position+Vector2(own.aimX*own.rayon,own.aimY*own.rayon)
	else:global_position = idle_pos.global_position
	if state==1 and not animation.is_playing():
		go_state0()
func go_state0():
	state = 0
	animation.play("idle")
func go_state1():
	state = 1
	animation.play("attack")
	
