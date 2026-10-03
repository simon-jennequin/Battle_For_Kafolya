extends STATE

class_name Idle


func enter(_prev):
	own.animation.play("idle")
	own.animation.speed_scale = 1
func update(_delta):
	_flip()
	own.animation.speed_scale = 1
	
	if not own.is_on_floor() and own.velocity.y<0:
		own.change_state("jump_asc")
	elif not own.is_on_floor() and own.velocity.y>=0:
		own.change_state("jump_dsc")
	elif own.moving:
		own.change_state("run")
	
	
func out(_next):
	pass
