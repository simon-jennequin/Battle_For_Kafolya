extends Node
@onready var player = AudioStreamPlayer.new()

func _ready():
	add_child(player)
	player.volume_db = -10
	player.autoplay = false
	player.process_mode = PROCESS_MODE_ALWAYS

func play_music(stream_path: String):
	var stream = load(stream_path)
	
	player.stream = stream
	player.play()

func stop_music():
	player.stop()
