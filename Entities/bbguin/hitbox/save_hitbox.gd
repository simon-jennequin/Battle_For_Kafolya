extends Area2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var own: CharacterBody2D = $".."

func activate():
	shape.set_deferred("disabled",false)
func desactivate():
	shape.set_deferred("disabled",true)
	



func _on_body_entered(body: Node2D) -> void:
	if body == own.papaguin:
		own.emit_signal("bb_saved")
		print("emit")
	
