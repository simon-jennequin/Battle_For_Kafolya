extends STATUS
class_name FREEZSTATUS



const FREEZ = preload("res://Entities/Peaceguin/freez/freez.tscn")
var inst
var pv_start


static func create():
	var script = preload("res://Common/Status_Management/Freez/freez.gd").new()
	return script
func enter():
	own.current.exit("idle")
	inst = FREEZ.instantiate()
	own.add_child(inst)
	own.velocity = Vector2.ZERO
	own.project_duration=0
	pv_start = own.hp
	
func update(delta):
	
	inst.global_position = own.global_position
	duration-=delta*1000
	
	if pv_start!=own.hp or duration<0:
		exit()
		

func exit():
	inst.destroy()
	own.status.suppr_status("freez")

func get_speed():
	return 0
func locks_movements():
	return true
func locks_actions():
	return true
