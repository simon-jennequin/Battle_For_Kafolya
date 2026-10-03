extends STATE

func enter(_prev):
	nom = "sad"
	own.is_saved = false
	own.animation.play("sad")
	own.save_hitbox.activate()
	own.bb_saved.connect(func():if own.is_saved==false:own.change_state("idle");own.is_saved=true;own.save_hitbox.desactivate())
	
func is_busy():
	return true
func exit(next):
	own.rotation=0
