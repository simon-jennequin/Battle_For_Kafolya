extends Area2D

@onready var shape: CollisionShape2D = $hitbox_shape
const SLASH_HIT = preload("res://Entities/Chobushi/sound/slash_hit.wav")
var all_hit = []
@onready var lance: CharacterBody2D = $".."

func activate():
	desactivate()
	all_hit = []
	shape.set_deferred("disabled",false)
	
func desactivate():
	shape.set_deferred("disabled",true)

func attack_hit(body):
	if body.layer==lance.own.layer:return
	
	body.take_damage(self,15)
	var stream = lance.get_node("stream")
	stream.stream = SLASH_HIT
	stream.pitch_scale=randf_range(0.8,1.2)
	stream.play()

	body.project(self,lance.direction,800)
		
func launch_hit(body):
	lance.collision(body)

	lance.lock(body)
	body.take_damage(self,6)
		
	

# Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body in all_hit:return
	all_hit.append(body)
	if not body is ENTITY and not body is OBJECT:return
	if body.is_invincible:return
	if body.layer==lance.layer:return
	if lance.states==1:launch_hit(body)
	if lance.states>=3:attack_hit(body)
	 # Replace with function body.
