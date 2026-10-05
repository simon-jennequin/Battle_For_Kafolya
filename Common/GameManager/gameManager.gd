extends SCENE

# Prélève les scènes nécessaires

var player :=preload("res://Common/GameManager/player.tscn")
var map = [preload("res://Stage/Mystik/Mystik.tscn")]


@onready var canvas_game: CanvasLayer = $CanvasGame
@onready var ending_round: AudioStreamPlayer2D = $ending_round




var all_player = []
var all_id = []
var end_round:= false
var map_choose
var starting = true
var teamplay = false
var friendlyfire = false
var direct =false
@onready var starting_node = [$CanvasGame,$Camera2D,$ending_round]


func _ready() -> void:
	
	if not direct:return
	var id1 = identity.simulate(1,[0,2],"green",2,"Xeto")
	var id2 = identity.simulate(0,[2,1],"red",1,"Slifos")
	var id3 = identity.simulate(2,[2,1],"yellow",2,"Yoxams")
	var id4 = identity.simulate(3,[0,1],"blue",1,"LILA")
	teamplay = false
	all_id.append(id1)
	all_id.append(id2)
	#all_id.append(id3)
	#all_id.append(id4)
	start_game(all_id,false,false)
	
	
	
	
func start_game(new_all_id,is_teamplay,is_friendlyfire):
	var map_chosen = map[0].instantiate()
	all_id = new_all_id
	teamplay = is_teamplay
	friendlyfire = is_friendlyfire
	var index = 0
	var start = 0
	var end = 3
	for id in all_id:
		id.score = 0
		if teamplay and id.team == 1:
			index = start
			start+=1
			id.index = index
		elif teamplay and id.team == 2:
			index = end
			end-=1
			id.index = index
		elif start <= 3 - end:
			index = start
			start+=1
			id.index = index
		else:
			index = end
			end-=1
			id.index = index

		id.start_position = map_chosen.start_pos[id.index]
		canvas_game.all_cadre[id.index].assignate(id)
	start_round()
	
func start_round():
	clear_scene()
	starting = true
	Engine.time_scale = 1
	end_round = false
	
	map_choose = map[0].instantiate()
	add_child(map_choose)
	camera.implement_limit(map_choose)
	for id in all_id:
		
		var play = player.instantiate()
		play.init(id,id.manette,id.persos,id.color,id.team,id.pseudo,id.start_position,self)
		all_player.append(play)
		add_child(play)
		
		canvas_game.all_cadre[id.index].setup(play)
	canvas_game.start()
	
func start_playing():
	starting = false
	
	for player in all_player:
		player.can_play=true
func clear_scene():
	all_player = []
	for child in self.get_children():
		if not child in starting_node:child.queue_free()
		

func player_dead(new_player):
	all_player.erase(new_player)
	verif_victory()
func verif_victory():
	end_round = true
	
	if len(all_player)>1:
		for i in range(len(all_player)-1):
			if all_player[i].team!=all_player[i+1].team:
				end_round= false

	if end_round:
		MusicManager.stop_music()
		ending_round.play()
		for player in all_player:
			player.id.score+=1	
func is_in_zone(delta):
	for player in all_player:
		
		if player.perso.global_position.x<camera.global_position.x-camera.get_weight()/2 or player.perso.global_position.x>camera.global_position.x+camera.get_weight()/2:
			player.perso.zone+=delta
			if player.perso.zone>=1.0:player.perso.zone=0.0;player.perso.take_damage(null,10.0)
		else:
			player.perso.zone = 0
func _physics_process(delta: float) -> void:
	is_in_zone(delta)
func _process(_delta: float) -> void:
	
	if end_round and Engine.time_scale>0.1:
		Engine.time_scale-=_delta
	elif end_round and Engine.time_scale<=0.1:
		start_round()
	
	if starting and canvas_game.is_finish:
		map_choose.start_music()
		start_playing()
	
	camera.update(all_player,_delta)
	
	pass
