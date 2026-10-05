extends STATE

func setup():
	own.bb_saved.connect(_on_bb_saved)

func _on_bb_saved():
	if own.is_saved: return
	own.change_state("idle")
	own.is_saved = true
	own.save_hitbox.desactivate()

func enter(_prev):
	nom = "sad"
	own.is_saved = false
	own.animation.play("sad")
	own.save_hitbox.activate()
	
func is_busy():
	return true
func exit(next):
	own.rotation=0
