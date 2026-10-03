extends CharacterBody2D
class_name PROJECTILE
var own
var gravite = 0
var layer = 0
var can_project = true
var is_alive=true
var speed = 0
var direction = Vector2.ZERO
var angle_ajust = 0

func spawn(perso,dir,force,pos):
	global_position = pos
	own = perso
	layer = perso.layer
	speed = force
	direction = dir
	velocity = speed*direction
func _physics_process(delta: float) -> void:
	
	velocity.y += gravite*delta
	
	move_and_slide()
func project(_perso,dir,force):
	if not can_project:return
	velocity = direction*force
func destroy():
	if is_alive:queue_free();is_alive=false
	
func collision(body):
	if body.collision_layer==8:
		destroy()
