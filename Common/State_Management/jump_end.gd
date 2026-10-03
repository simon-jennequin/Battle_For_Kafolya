extends STATE




func enter(_prev):
	own.animation.play("jump_end")
	
func update(_delta):
	_flip()
	
	own.animation.speed_scale = 1
	if own.animation.is_playing():return
	
	if not own.is_on_floor() and own.velocity.y<0:
		own.change_state("jump_asc")
	elif not own.is_on_floor() and own.velocity.y>=0:
		own.change_state("jump_dsc")
	elif own.moving:
		own.change_state("run")
	elif not own.moving:
		own.change_state("idle")
