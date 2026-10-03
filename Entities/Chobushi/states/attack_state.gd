extends STATE

var t0
var end = false
var direction
var state =0
func enter(_prev):
	if not own.is_aim:direction = Vector2(own.direction,0).normalized()
	else:direction = Vector2(own.aimX,own.aimY).normalized()
	own.lance.attack(direction)
	t0 = Time.get_ticks_msec()
	if direction.x<0:
		own.lance.z_index=0
	else:
		own.lance.z_index = -1
	
	start_state()
func update(_delta):
	if state==0 and not own.animation.is_playing():
		go_neutral_state()
	elif state == 1 and Time.get_ticks_msec()-t0>500:
		go_end_state()
	elif state == 2 and not own.animation.is_playing():
		own.change_state("idle")
	
	
func start_state():
	state=0
	if abs(direction.x)>abs(direction.y):
		own.animation.play("atk_side")
		
	elif direction.y<0: 
		own.animation.play("atk_up")
		
	else: 
		own.animation.play("atk_down")
	if own.is_aim:	_flip_aim()
	
	
func go_neutral_state():
	state = 1
	own.lance.states = 4
func go_end_state():
	if abs(direction.x)>abs(direction.y):
		own.animation.play("atk_side_end")
		
	elif direction.y<0: 
		own.animation.play("atk_up_end")
		
	else: 
		own.animation.play("atk_down_end")
		
	state=2
	own.lance.states=5
func exit(next):
	super(next)
	own.lance.reset()
	own.direction = direction.x
func is_busy():
	return true
func get_speed():return 0.5
