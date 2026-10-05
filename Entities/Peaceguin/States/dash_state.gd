extends STATE

var sens
var t0



var state = 0

func setup():
	own.stop_dash.connect(_on_stop_dash)

func _on_stop_dash():
	if own.current != self: return
	go_state2()

func enter(_prev):
	
	var dash_hitbox = own.get_node("dash_hitbox")
	var hurtbox = own.get_node("hurtbox")
	var dash_hurtbox = own.get_node("dash_hurtbox")
	var dash_stream = own.get_node("dash_stream")
	dash_stream.pitch_scale= randf_range(0.8, 1.2)
	dash_stream.play()
	hurtbox.disabled = true
	dash_hurtbox.disabled = false
	own.animation.play("dash_start")
	if own.animation.flip_h:
		sens = 1
		
	else:
		sens=-1
	dash_hitbox.activate(sens)
	dash_hitbox.position.x=sens*abs(dash_hitbox.position.x)
	dash_hurtbox.position.x = sens*abs(dash_hurtbox.position.x)
	own.is_dash=true
	t0 = Time.get_ticks_msec()
	state=0
	
func update(_delta):
	own.direction = sens
	if state!=2 and own.is_on_floor():own.velocity.x = 1500*sens
	elif state!=2:own.velocity.x = 1000*sens
	elif state==2:own.velocity.x = 400*sens
	if state==0:
		if not own.animation.is_playing():
			go_state1()
	elif state==1:
		if Time.get_ticks_msec()-t0>1000:go_state2()
	elif state==2:
		if not own.animation.is_playing():own.change_state("idle")
			
func go_state1():
	state =1
	own.animation.play("dash_idle")
	t0 = Time.get_ticks_msec()
func go_state2():
	own.velocity.x = 300*sens
	var dash_hitbox = own.get_node("dash_hitbox")
	state=2
	own.animation.play("dash_end")
	dash_hitbox.desactivate()
	
func exit(next):
	var dash_hitbox = own.get_node("dash_hitbox")
	var hurtbox = own.get_node("hurtbox")
	var dash_hurtbox = own.get_node("dash_hurtbox")
	
	hurtbox.set_deferred("disabled",false)
	dash_hurtbox.set_deferred("disabled",true)
	own.velocity.x=0
	own.is_dash=false
	dash_hitbox.desactivate()
	own.SPELL1_USED = false
	if next!="":own.current=own.states[next];own.current.enter(self)
	
func is_busy():return true
	
func locks_movements():return true
