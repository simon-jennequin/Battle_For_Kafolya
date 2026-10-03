extends STATE


func enter(prev):
	var stream = own.get_node("punch1_stream")
	stream.stream = load("res://Entities/Peaceguin/sound/rate1.wav")
	stream.pitch_scale = randf_range(0.8,1.2)
	stream.play()
	own.animation.speed_scale = 1
	prev.exit("")
	own.animation.play("lancer")
	
	
	if own.aimX>0:
		own.animation.flip_h = true
	else:
		own.animation.flip_h = false
	
func update(_delta):
	if own.animation.is_playing():return
	exit("")
	own.change_state("idle")

	
func is_busy():
	return true
