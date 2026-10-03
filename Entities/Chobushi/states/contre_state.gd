extends STATE

var t0
var idle


const CONTRE_LAUNCH = preload("res://Entities/Chobushi/sound/contre_launch.wav")
func enter(_prev):
	var contre_stream = own.get_node("contre_stream")
	contre_stream.stream = CONTRE_LAUNCH
	contre_stream.pitch_scale = randf_range(0.8,1.2)
	contre_stream.play()
	own.animation.play("contre_creation")
	own.contre_activate.connect(func():own.change_state("contre_end"))
	
	own.contre_damage = 10
	t0 = Time.get_ticks_msec()
	own.is_counter = true
	
	
	

func update(_delta):

	if Time.get_ticks_msec()-t0>2000:
		own.change_state("contre_end")
		
	
	
func exit(next):
	super(next)
	own.is_counter = false
	own.SPELL2_USED = false
	
func is_busy():return true
	
func locks_movements():return true

func locks_projections():return true
func get_vulnerable():return 0.0	
func locks_status():return true
