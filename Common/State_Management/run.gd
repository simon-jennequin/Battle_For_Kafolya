extends STATE




func enter(_prev):
	own.animation.play("run")
func update(_delta):
	_flip()
	own.animation.speed_scale = own.moving_speed
	
	if not own.is_on_floor() and own.velocity.y<0:
		own.change_state("jump_asc")
	elif not own.is_on_floor() and own.velocity.y>=0:
		own.change_state("jump_dsc")
	elif not own.moving:
		own.change_state("idle")
	
func exit(next):
	own.animation.speed_scale = 1
