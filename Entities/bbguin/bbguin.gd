extends ENTITY




var papaguin
var distanceX
var distanceY
var distance_max = 250
var is_saved = true
var t0 = 0
var all_hit = []

signal bb_saved
@onready var save_hitbox: Area2D = $save_hitbox
@onready var lance_hitbox: Area2D = $lance_hitbox

const FREEZ = preload("res://Entities/Peaceguin/freez/freez.tscn")
func _ready() -> void:
	super()
	hp = max_hp

	add_state(preload("res://Entities/bbguin/States/lancer_state.gd"),"lancer")
	add_state(preload("res://Entities/bbguin/States/Sad_state.gd"),"sad")
	

func ai():
	distanceX=(papaguin.global_position.x-global_position.x)
	distanceY = (papaguin.global_position.y-global_position.y)
	if abs(distanceX)>distance_max:
		if distanceX<0:
			move(-1)
		else:
			move(1)
	if abs(distanceY)>distance_max:
		if distanceY<0 and velocity.y>=0:
			jump(false,true)
	
func spawn(new_papaguin,new_game):
	self.papaguin = new_papaguin
	layer = papaguin.layer
	global_position = papaguin.global_position
	game = new_game
	c = papaguin.c
	couleur = papaguin.couleur
	parent = new_game
func disapear():
	super()
	papaguin.SPELL2_USED = false
	papaguin.SPELL2 = 0.0
func launch(x,y):
	aim(x,y,true)
	change_state("lancer")
	


func _process(delta: float) -> void:
	
	is_controlled=true
	if not physique:move_and_slide();current.update(delta);
	if not current.is_busy():
		ai()


	
func death():
	super()
	papaguin.SPELL2 = 8.0
	papaguin.SPELL2_USED = false
	
		
func sprite():
	pass		

	
	
