extends STATE
var cancel
var explosion
const CONTRE_HIT = preload("res://Entities/Chobushi/sound/contre_hit.wav")
func enter(_prev):
	
	var stream = own.get_node("contre_stream")
	stream.stream = CONTRE_HIT
	stream.play()
	cancel=false
	own.animation.play("contre_final")
	explosion = COUNTER.create(own)
func update(_delta):
	if cancel:own.change_state("idle")
	if own.animation.is_playing():return
	
	exit("")
	own.change_state("idle")
	
func exit(next):

	cancel = true
	explosion.destroy()
	own.is_counter = false
	
	

func is_busy():return true
	
func locks_movements():return true
func locks_actions():return true
