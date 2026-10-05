extends Node
var own
var active = {}


var locks_actions := false
var locks_movements := false
var locks_projections := false
var locks_status :=false
var speed_mult :float=1.0
var gravite
var is_invincible = false
var locks_jump = false

var vulnerable
func update(dt: float) -> void:
	for status in active.keys():
		active[status].update(dt)
	_recompute()

func apply(inst, duration: float, status: StringName) -> void:
	if own.locks_status:return
	inst.own = own
	if status in active.keys() and active[status].duration<duration:
		active[status].duration = duration
		
	elif status not in active.keys():
		active[status] = inst
		active[status].enter()
		active[status].duration = duration
		
	_recompute()
func has(status):
	return active.has(status)
func suppr_status(status):
	if not active.has(status): return
	active.erase(status)
	
func clear(status: StringName) -> void:
	if not active.has(status): return
	active[status].exit(); _recompute()
func clear_all():
	for status in active.keys():
		clear(status)
		
	_recompute()
func _recompute() -> void:
	locks_actions = own.current.locks_actions()
	locks_movements = own.current.locks_movements()
	is_invincible = own.current.is_invincible()
	locks_projections = own.current.locks_projections()
	speed_mult = own.current.get_speed()
	vulnerable = own.current.get_vulnerable()
	locks_status = own.current.locks_status()
	gravite = own.current.get_gravite()
	locks_jump = own.current.locks_jump()
	for status in active.keys():
		
		locks_actions  = locks_actions  or active[status].locks_actions()
		locks_movements = locks_movements or active[status].locks_movements()
		locks_projections = locks_projections or active[status].locks_projections()
		is_invincible = is_invincible or active[status].is_invincible()
		speed_mult *=active[status].get_speed()
		vulnerable *= active[status].get_vulnerable()
		locks_status = locks_status or active[status].locks_status()
		gravite *= active[status].get_gravite()
		locks_jump = locks_jump or active[status].locks_jump()
		
	own.locks_actions = locks_actions
	own.locks_movements = locks_movements
	own.locks_projections = locks_projections
	own.is_invincible = is_invincible
	own.speed_mult = speed_mult
	own.vulnerable = vulnerable
	own.gravite = gravite
	own.locks_status = locks_status
	own.locks_jump = locks_jump
	
