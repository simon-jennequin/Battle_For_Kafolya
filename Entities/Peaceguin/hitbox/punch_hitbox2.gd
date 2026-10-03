extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var order
var all_hit = []

@onready var own: CharacterBody2D = $".."
var dir
func activate(new_order,new_dir):
	if not collision_shape_2d.disabled:return
	collision_shape_2d.set_deferred("disabled",false)
	self.order = new_order
	all_hit = []
	self.dir = new_dir
func desactivate():
	collision_shape_2d.set_deferred("disabled",true)


	

func _on_body_entered(body: Node2D) -> void:
	if body in all_hit:return
	all_hit.append(body)
	if body.has_method("project_peaceguin"):body.project_peaceguin(dir.x,900)
	if not body is ENTITY and not body is OBJECT:return
	if body.is_invincible:return
	var punch2_stream = own.get_node("punch2_stream")
	
	if body.layer==own.layer:return
	punch2_stream.stream = load("res://Entities/Peaceguin/sound/hit2.wav")
	punch2_stream.pitch_scale = randf_range(0.8,1)
	punch2_stream.play()
	if body is ENTITY:
		if  body.status.has("freez"):
			body.take_damage(own,25)
			body.project(own,dir,1600)
		else:
			body.take_damage(own,10)
			body.project(own,dir,800)
			
	else:
		body.take_damage(own,25)
		body.project(own,dir,800)
			
		
