extends Area2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var order
var all_hit = []

const Freez = preload("res://Common/Status_Management/Freez/freez.gd")
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
	if body.has_method("project_peaceguin"):body.project_peaceguin(dir.x,300)
	if not body is ENTITY :return
	if body.is_invincible:return
	var stream = own.get_node("punch1_stream")
	if body in all_hit:return
	all_hit.append(body)
	
	
	if body.layer==own.layer:return


	stream.stream = load("res://Entities/Peaceguin/sound/hit1.wav")
	stream.play()
	body.status.apply(Freez.new(),800,"freez")
	

		
