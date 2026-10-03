extends STATE

var dir
var distance = 100
var punch_hitbox
var direction
var state = 0
func enter(prev):
	state = 0
	own.animation.speed_scale = 1
	prev.exit("")
	punch_hitbox = own.get_node_or_null("punch_hitbox1")
	direction = Vector2(own.aimX,own.aimY)
	var a 
	var b 
	var punch1_stream = own.get_node("punch1_stream")
	punch1_stream.stream = load("res://Entities/Peaceguin/sound/rate1.wav")
	punch1_stream.pitch_scale = randf_range(0.8,1.2)
	punch1_stream.play()
	if not own.is_aim:direction=Vector2(own.direction,0)
	if absf(direction.x)>absf(direction.y):
		b = -0.15
		own.animation.play("punch_side1")
	elif direction.y<0:
		b = -1
		own.animation.play("punch_up1")
	else :
		b = 1
		own.animation.play("punch_down1")
	if direction.x<0:
		a = -0.5
		own.animation.flip_h = false
	else:
		a = 0.5
		own.animation.flip_h = true
	dir = Vector2(a,b).normalized()
	own.go_punch2.connect(func(): if own.animation.frame ==4 or state==1:own.change_state("punch2"))
func update(_delta):
	punch_hitbox.global_position = own.global_position + dir*distance
	if own.animation.frame>=1 and state==0:punch_hitbox.activate(1,dir)
	if state==0 and not own.animation.is_playing():go_end()
	if state==1 and not own.animation.is_playing():own.change_state("idle")
func exit(next):
	
	own.direction = direction.x
	punch_hitbox = own.get_node_or_null("punch_hitbox1")
	punch_hitbox.desactivate()
func go_end():
	state=1
	punch_hitbox.desactivate()
	if absf(direction.x)>absf(direction.y):
		own.animation.play("punch_side1_end")
	elif direction.y<0:
		own.animation.play("punch_up1_end")
	else :
		own.animation.play("punch_down1_end")
	
func is_busy():
	return true
func get_speed():return 0.4

func locks_jump():
	return true
