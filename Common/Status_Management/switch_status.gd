extends STATUS


func update(_delta):
	if own.current.is_busy() or own.is_controlled:
		exit()

func exit():
	own.status.suppr_status("switch")
func is_invincible():return true
