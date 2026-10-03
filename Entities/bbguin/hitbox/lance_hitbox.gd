extends Area2D
@onready var own: CharacterBody2D = $".."
@onready var shape: CollisionShape2D = $CollisionShape2D
const Freez = preload("res://Common/Status_Management/Freez/freez.gd")
var all_hit=[]
func activate():
	desactivate()
	shape.set_deferred("disabled",false)
	all_hit= []
	
func desactivate():
	shape.set_deferred("disabled",true)

	

func _on_body_entered(body: Node2D) -> void:
	if not body is ENTITY:return
	if body.is_invincible:return
	if body.layer==own.layer:return
	body.status.apply(Freez.new(),800,"freez")
