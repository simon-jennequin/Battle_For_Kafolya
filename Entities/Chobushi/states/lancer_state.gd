extends STATE
var direction
func enter(_prev):
	own.animation.play("lancer")
	direction = own.aimX
	if own.aimX<0:
		own.animation.flip_h = false
	else:
		own.animation.flip_h = true
		
func update(_delta):
	if own.animation.is_playing():return
	own.change_state("idle")
func exit(next):
	super(next)
	own.direction=direction
func is_busy():
	return true
func get_speed():return 0.1
	
