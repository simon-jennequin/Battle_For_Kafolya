extends Area2D
class_name BREEZWIND

static func initialize(new_own, dir):
	const WIND = preload("res://Entities/Breez/Wind/wind.tscn")
	var inst = WIND.instantiate()
	inst.init(new_own,dir)
	Engine.get_main_loop().current_scene .add_child(inst)
	
	

var own
var layer
var force=1300
var direction

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation.rotation = direction.angle() + deg_to_rad(180)
	pass # Replace with function body.

func init(perso,dir):
	own = perso
	layer = perso.layer
	direction = dir
	global_position = own.global_position+direction*50
	own.velocity = -direction*force

			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not animation.is_playing():
		
		
		
		queue_free()
	


func _on_body_entered(body: Node2D) -> void:
	if body==own:
		return
	
	if body.has_method("project"):
		body.project(own,direction,force)
	if body is PROJECTILE:
		body.layer=own.layer

	


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("project"):
		area.project(own,direction,1600)
