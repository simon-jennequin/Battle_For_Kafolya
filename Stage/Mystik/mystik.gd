extends Node2D

@onready var marker2: Marker2D = $ParallaxBackground/ParallaxLayer0/Marker2
@onready var marker1: Marker2D = $ParallaxBackground/ParallaxLayer0/Marker1

@onready var limit_left = marker2.global_position.x
@onready var limit_right = marker1.global_position.x
@onready var limit_top = marker1.global_position.y
@onready var limit_bot = marker2.global_position.y
const THEME1 = "res://Stage/Mystik/music/ways-of-the-wizard-197105.mp3"
const THEME2 = "res://Stage/Mystik/music/witches-cauldron-153084.mp3"
const THEME3 = "res://Stage/Mystik/music/woodland-tales-167533.mp3"

var list_music = [THEME1,THEME2,THEME3]
var position1 := Vector2(-900,315)
var position2 :=Vector2(-435,0)
var position3:=Vector2(275,0)
var position4:=Vector2(720,315)


var start_pos = [position1,position2,position3,position4]


	
	
func start_music():
	MusicManager.play_music(list_music.pick_random())
func get_height():
	return -(limit_top-limit_bot)
