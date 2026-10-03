extends Area2D

@onready var hitbox: CollisionShape2D = $CollisionShape2D

const CONTRE_HIT = preload("res://Entities/Chobushi/sound/contre_hit.wav")
var own
var all_hit = []
func activate(new_own):
	
	self.own = new_own
	self.hitbox.set_deferred("disabled",false)
func desactivate():
	all_hit=[]
	self.hitbox.set_deferred("disabled",true)

func _on_body_entered(body: Node2D) -> void:
	if body in all_hit:return
	all_hit.append(body)
	if not body is ENTITY and not body is OBJECT:return
	if body.is_invincible:return
	if own.layer==body.layer:return
	
	var direction = (body.global_position-own.global_position).normalized()
	var force = (float(own.contre_damage)/float(20))*1400
	
	print("oui j ai mal,", force)
	body.take_damage(own,own.contre_damage)
	body.project(own,direction,force)
	 # Replace with function body.
