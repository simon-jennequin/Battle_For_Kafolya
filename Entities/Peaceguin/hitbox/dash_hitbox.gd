extends Area2D


@onready var own: CharacterBody2D = $".."
@onready var dash_hitbox: CollisionShape2D = $dash_Hitbox
@onready var area: Area2D = $"."


var all_hit = []
var sens
var dir = Vector2(1,1).normalized()
var hit
func activate(new_sens):
	dash_hitbox.set_deferred("disabled",false)
	
	all_hit = []
	self.sens = new_sens
	
	
func desactivate():
	dash_hitbox.set_deferred("disabled",true)
	
	
	


func _on_body_entered(body: Node2D) -> void:
	if not body is ENTITY and not body is OBJECT:return
	if body.is_invincible:return
	if body in all_hit: return
	all_hit.append(body)
	
	if body.has_method("project_peaceguin"):body.velocity.x = own.velocity.x
	
	if body.layer == own.layer : return
	var stream = own.get_node("dashhit_stream")
	stream.stream = load("res://Entities/Peaceguin/sound/hit1.wav")
	stream.pitch_scale= randf_range(0.8, 1.2)
	stream.play()
	body.take_damage(own,10)
	
	body.project(own,dir*sens,1500)
