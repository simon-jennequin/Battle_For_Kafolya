extends STATE

class_name JumpAsc


func enter(_prev):
	own.animation.play("jump_asc")
	
func update(_delta):
	_flip()
	own.animation.speed_scale = 1
	
	if own.is_on_floor():
		own.change_state("jump_end")
	elif own.velocity.y>=0:
		own.change_state("jump_dsc")
