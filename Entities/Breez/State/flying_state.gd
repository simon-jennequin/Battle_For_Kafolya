extends STATE
const PLANNAGE = preload("res://Entities/Breez/sound/plannage.wav")
func enter(_prev):
	
	own.velocity.y = 0
	own.animation.play("jump_dsc")
	own.go_down.connect(func():if own.current==own.states["flying"]:own.change_state("idle"))
	own.projected.connect(func():if own.current==own.states["flying"]:own.change_state("idle"))
	own.jumped.connect(func():if own.current==own.states["flying"]:own.change_state("idle"))
	own.footstep.stream = PLANNAGE
	own.footstep.pitch_scale = randf_range(1,1.2)
	own.footstep.play()
func update(_delta):
	_flip()
	if own.is_on_floor():
		own.change_state("idle")
func get_gravite():return 0.02
	
