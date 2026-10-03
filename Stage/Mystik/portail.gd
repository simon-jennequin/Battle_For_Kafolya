extends Area2D

@export var portail2 :Area2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: CollisionShape2D = $CollisionShape2D

var state = 0
var t0 = 0
func _physics_process(delta: float) -> void:
	if state==2 and Time.get_ticks_msec()-t0>20000:
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
	t0 = Time.get_ticks_msec()
	

		

func _on_body_entered(body: Node2D) -> void:
	if body is ENTITY:
		body.global_position = portail2.global_position
		portail2.destruction()
		destruction()
	
