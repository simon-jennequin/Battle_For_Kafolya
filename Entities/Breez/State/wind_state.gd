extends STATE
var state=0
var direction
const BREEZ_WIND = preload("res://Entities/Breez/Wind/breez_wind.wav")

func enter(_prev):
	state= 0
	direction = own.wind_direction
	if not own.is_aim:direction=Vector2(0,1).normalized();
	if absf(direction.x)>absf(direction.y):
		own.animation.play("wind_side")
	elif direction.y<0:
		own.animation.play("wind_up")
	else :
		own.animation.play("wind_down")
	if own.is_aim:_flip_aim();
	
	own.windStream.pitch_scale = randf_range(1,1.2)
	own.windStream.play()
	BREEZWIND.initialize(own,direction)
func update(_delta):
	if state ==0 and not own.animation.is_playing(): own.change_state("idle")
	
func exit(next):
	super(next)
	own.direction = direction.x
		
func get_speed():return 0
func locks_jump():return true
	
