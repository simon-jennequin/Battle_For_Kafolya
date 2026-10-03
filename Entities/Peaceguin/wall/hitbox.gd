extends Area2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var ice_wall: ICEWALL = $".."

func activate():
	shape.set_deferred("disabled",false)
func desactivate():
	shape.set_deferred("disabled",true)
	


func _on_body_entered(body: Node2D) -> void:
	if not body is ENTITY :return
	if body.is_invincible:return
	if body.layer == ice_wall.layer:return
	
	body.apply_status(FREEZSTATUS.create(),1200,"freez")
	ice_wall.destroy()
