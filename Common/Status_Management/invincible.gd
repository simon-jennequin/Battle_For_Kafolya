extends STATUS

class_name INVINCIBLE

static func create():
	var inst = preload("res://Common/Status_Management/invincible.gd").new()
	return inst

func is_invincible():return true

func update(_delta):
	if duration>0:
		duration-=_delta*1000
	elif duration<=0:
		own.status.suppr_status("invincible")
		
func exit():
	own.status.suppr_status("invincible")
