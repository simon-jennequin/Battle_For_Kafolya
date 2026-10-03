extends Node
class_name SWITCH
@export var animation :AnimatedSprite2D
@export var reference :ENTITY
#@export var stream:AudioStreamPlayer2D
@onready var stream: AudioStreamPlayer2D = $AudioStreamPlayer2D

const DISAPEAR = preload("res://Entities/sound/disapear.wav")
static func create(own):
	if own.switch==null:return
	var inst = own.switch.instantiate()
	inst.reference = own
	inst.global_position = own.global_position
	Engine.get_main_loop().current_scene.add_child(inst)

func _ready() -> void:
	animation.scale = reference.animation.scale
	animation.flip_h = reference.animation.flip_h
	stream.stream = DISAPEAR
	stream.pitch_scale = randf_range(reference.intonation[0],reference.intonation[1])
	stream.play()
	
func _process(delta: float) -> void:
	if not animation.is_playing() and not stream.playing:
		queue_free()
