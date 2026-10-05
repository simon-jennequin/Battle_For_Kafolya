extends STATE
const PLANNAGE = preload("res://Entities/Breez/sound/plannage.wav")

func setup():
	own.go_down.connect(_stop_flying)
	own.projected.connect(_stop_flying)
	own.jumped.connect(_stop_flying)

func _stop_flying():
	if own.current != self: return
	own.change_state("idle")

func enter(_prev):

	own.velocity.y = 0
	own.animation.play("jump_dsc")
	own.footstep.stream = PLANNAGE
	own.footstep.pitch_scale = randf_range(1,1.2)
	own.footstep.play()
func update(_delta):
	_flip()
	if own.is_on_floor():
		own.change_state("idle")
func get_gravite():return 0.02
	
