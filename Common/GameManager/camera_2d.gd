extends Camera2D

@export var min_zoom := 0.5  # plus petit zoom (dézoome max)
@export var max_zoom := 1   # plus grand zoom (zoome max)
@export var padding := 200   # marge autour des joueurs
@export var lerp_speed := 0.1 
@onready var marker_right: Marker2D = $MarkerRight
@onready var marker_left: Marker2D = $MarkerLeft
const READY = preload("res://Common/font/ready.tscn")
var ready_label
const GO = preload("res://Common/font/go.tscn")
var go_label

var shake_amount =0
var shake_strength 
var distance_min = 1000
@export var game:SCENE

func _ready() -> void:
	enabled = true
	top_level = false
	
func implement_limit(map):
	limit_left = map.limit_left
	limit_right = map.limit_right
	limit_top = map.limit_top
	limit_bottom = map.limit_bot
	
# fluidité des mouvements
func update(players,delta):
	if players.is_empty():
		return

	# Calculer la boîte qui contient tous les joueurs
	var min_x = players[0].perso.global_position.x
	var max_x = players[0].perso.global_position.x
	var min_y = players[0].perso.global_position.y
	var max_y = players[0].perso.global_position.y
	for p in players:
		var pos = p.perso.global_position
		min_x = min(min_x, pos.x)
		max_x = max(max_x, pos.x)
		min_y = min(min_y, pos.y)
		max_y = max(max_y, pos.y)
		if p.is_ancestor_of(p.perso2):
			pos = p.perso2.global_position
			min_x = min(min_x, pos.x)
			max_x = max(max_x, pos.x)
			min_y = min(min_y, pos.y)
			max_y = max(max_y, pos.y)

	# Centre de la boîte = position cible de la caméra
	var target_pos = Vector2((min_x + max_x) *0.5, (min_y + max_y)*0.5)
	
	global_position = global_position.lerp(target_pos,lerp_speed)
	
	
	if ((max_x-min_x)/get_weight()>0.75 or (max_y-min_y)/get_height()>0.40) and get_height()<game.map_choose.get_height():
		var coef = 0.1
		if (max_x-min_x)/get_weight()>1 or (max_y-min_y)/get_height()>1:
			coef = 1
		zoom=Vector2(zoom.x-delta*coef,zoom.y-delta*coef)
	elif (max_x-min_x)/get_weight()<0.60 and (max_y-min_y)/get_height()<0.25  and zoom.x<=1:
		zoom=Vector2(zoom.x+delta*0.1,zoom.y+delta*0.1)

func put_ready():
	ready_label = READY.instantiate()
	add_child(ready_label)
func put_go():
	go_label = GO.instantiate()
	add_child(go_label)
	
func clear():
	remove_child(ready_label)
	remove_child(go_label)
	
	#zoom = zoom.lerp(target_zoom, lerp_speed)
func get_border_right():
	return global_position.x+get_weight()/2
	
func get_border_left():
	return global_position.x-get_weight()/2
func get_height():
	return get_viewport_rect().size.y*1/zoom.y
func get_weight():
	return get_viewport_rect().size.x*1/zoom.x
func get_top():
	var larger = get_viewport_rect().size.y*1/zoom.y
	
	return global_position.y-larger/2
	
func get_bot():
	var larger = get_viewport_rect().size.y*1/zoom.y
	
	return global_position.y+larger/2
func get_left():
	var larger = get_viewport_rect().size.x*1/zoom.x
	
	return global_position.x-larger/2
func get_right():
	var larger = get_viewport_rect().size.x*1/zoom.x
	
	return global_position.x+larger/2
func shake(duration,force):
	shake_amount = duration
	shake_strength = force
func _process(_delta: float) -> void:
	if shake_amount > 0:
		shake_amount -= _delta 
		var rng = RandomNumberGenerator.new()
		offset = Vector2(
			rng.randf_range(-shake_strength, shake_strength),
			rng.randf_range(-shake_strength, shake_strength)
		)
	else:
		offset = Vector2.ZERO
