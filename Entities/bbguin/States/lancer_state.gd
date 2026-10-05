extends STATE
var speed=1200
var angle_ajust = 90
var lance_hitbox
var direction
var wall
func enter(_prev):
	lance_hitbox = own.get_node_or_null("lance_hitbox")
	own.global_position = own.papaguin.global_position
	
	direction = Vector2(own.aimX,own.aimY).normalized()
	own.animation.play("attack")
	_flip_aim()
	own.rotation = direction.angle()+deg_to_rad(angle_ajust)
	own.velocity = direction*speed
	own.physique = false
	own.is_saved=false
	lance_hitbox.activate()
func update(_delta):
	#own.global_position +=own.velocity*delta
	if own.is_on_wall() or own.is_on_ceiling():
		own.change_state("sad")
	if own.is_on_floor():
		if wall!=null:wall.destroy()
		wall = ICEWALL.create(own,0,direction,own.global_position)
		own.change_state("sad")
func exit(next):
	own.physique = true
	own.rotation=0
	lance_hitbox.desactivate()
func is_busy():
	return true
func is_invincible():
	return true
