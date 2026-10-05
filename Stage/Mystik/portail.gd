extends Area2D

@export var portail2 :Area2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: CollisionShape2D = $CollisionShape2D

var state = 0
var elapsed := 0.0
func _physics_process(delta: float) -> void:
	elapsed += delta
	if state==2 and elapsed>20.0:
		creation()
	elif state==0 and not animation.is_playing():
		idle()
	
func creation():
	animation.play("creation")
	state=0
	
func idle():
	hurtbox.set_deferred("disabled",false)
	animation.play("idle")
	state=1
func destruction():
	hurtbox.set_deferred("disabled",true)
	animation.play("destruction")
	state=2
	elapsed = 0.0
	

		

func _on_body_entered(body: Node2D) -> void:
	if body is ENTITY:
		body.global_position = portail2.global_position
		portail2.destruction()
		destruction()
	
