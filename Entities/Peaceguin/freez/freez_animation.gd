extends Node

const FREEZ = preload("res://Entities/Peaceguin/sound/glace.wav")
const BREAKER = preload("res://Entities/Peaceguin/sound/breaker.wav")
@onready var animations: AnimatedSprite2D = $animations
var destroyed = false
@onready var freez_stream: AudioStreamPlayer2D = $freez_stream

func _ready() -> void:
	freez_stream.stream = FREEZ
	freez_stream.pitch_scale = randf_range(0.8,1.2)
	freez_stream.play()
func start():
	
	
	animations.play("freez")
func destroy():
	
	freez_stream.stream = BREAKER
	freez_stream.pitch_scale = randf_range(0.8,1.2)
	freez_stream.play()
	destroyed = true
	animations.play("destruction")
	
func _process(_delta: float) -> void:
	if destroyed and not animations.is_playing():
		queue_free()
