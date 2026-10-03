extends Node


@onready var socle: AnimatedSprite2D = $socle
@onready var flag: AnimatedSprite2D = $flag
@onready var movement: AnimationPlayer = $flag/movement
@onready var flamme: AnimatedSprite2D = $Flamme


@onready var cadre: Node2D = $"."
@onready var label: Label = $flag/CenterContainer/Label
@onready var all_pseudo: PanelContainer = $all_pseudo
@onready var container: VBoxContainer = $all_pseudo/VBoxContainer
@onready var teamflag: AnimatedSprite2D = $flag/teamflag
@onready var flamme_stream: AudioStreamPlayer2D = $flammeStream
@onready var entry_stream: AudioStreamPlayer2D = $entryStream


const FLAMME_NOT_READY = preload("res://Menu/Selection/sound/flamme_not_ready.wav")
const FLAMME_READY = preload("res://Menu/Selection/sound/flamme_ready.wav")

var own 
var flamme_state
var flag_state
var socle_state
var selection
var all_buttons = []
var pos = [Vector2(-45,0),Vector2(45,0)]
var chara = []
var color
func start(id,menu):
	if menu.teamplay:
		if id.team==1:color="blue"
		else:color="red"
	else:color = id.color
	cadre.visible = true
	own = id
	selection = menu
	flag_state = "start_"
	flag.play(flag_state+color)
	socle.play("start")
	socle_state = "start"
	movement.play("move")
	label.text = id.pseudo
	id.IS_READY.connect(func():go_ready())
	id.NOT_READY.connect(func():not_ready())
	id.COLOR_CHANGED.connect(func():change_color())
	menu.SWAP_PSEUDO.connect(func():reset_pseudo())
	entry_stream.play()
	return self
func cancel():
	movement.play("cancel")
	socle.play("end")
	if own.is_ready:
		not_ready()
		
func _process(delta: float) -> void:
	if flag_state=="start_" and not flag.is_playing():
		flag_state = "idle_"
		flag.play("idle_"+color)
		
		
		
	if socle_state=="start" and not socle.is_playing():
		socle_state = "idle"
		socle.play("idle")
		
		
	if flamme_state=="start_" and not flamme.is_playing():
		flamme_state = "idle_"
		flamme.play("idle_"+color)
		
	
func change_color():
	
	if selection.teamplay:
		teamflag.visible=true
		if own.team==1:color="blue";teamflag.play("blue")
		else:color="red";teamflag.play("red")
	else:
		color =own.color
		teamflag.visible=false
		

	var flag0 = flag.frame
	flag.play(flag_state+color)
	flag.frame = flag0
	if flamme_state!=null:
		var flamme0 = flamme.frame
		flamme.play(flamme_state+color)
		flamme.frame = flamme0
	if own.show_pseudo:reset_pseudo()
		
func go_ready():
	flamme.visible=true
	flamme.play("start_"+color)
	flamme_state = "start_"
	flamme_stream.stream = FLAMME_READY
	flamme_stream.play()
func not_ready():
	flamme.play("end_"+color)
	flamme_state = "end_"
	flamme_stream.stream = FLAMME_NOT_READY
	flamme_stream.play()
func reset_pseudo():
	
	var nb = len(selection.all_profiles)-len(container.get_children())
	
	if nb>0:
		for i in range(nb):
			var new_button = PSEUDO_BUTTON.create(self)
			container.add_child(new_button)
			cadre.all_buttons.append(new_button)
	elif nb<0:
		for i in range(abs(nb)):
			var child = container.get_child(container.get_child_count()-1)
			container.remove_child(child)
			all_buttons.remove_at(all_buttons.size()-1)
			
	
	var i = 0
	for node in container.get_children():
		
		node.change(selection.all_profiles[i],color)
		i+=1
		
		
func spawn_chara():
	var new_char = SceneManager.all_char[own.persos[len(own.persos)-1]].instantiate()
	var new_pos = pos[len(own.persos)-1]+self.global_position
	if len(own.persos)==1:
		new_char.direction=1
	else:
		new_char.direction=-1
	new_char.appear(selection,new_pos)
	chara.append(new_char)
func dispawn_chara():
	var old_char = chara[-1]
	chara.remove_at(len(chara)-1)
	old_char.disapear()
	
func unprint_pseudo():
	label.visible = true
	all_pseudo.visible = false
	
func print_pseudo():
	label.visible = false
	all_pseudo.visible = true
	reset_pseudo()
