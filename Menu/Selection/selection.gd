extends SCENE
var all_id = []
var all_devices = []
var all_colors = ["blue","red","green","yellow"]
const GAME = preload("res://Common/GameManager/Game.tscn")
var y = 180
var all_pos = [Vector2(-180,y),Vector2(-460,y),Vector2(180,y),Vector2(460,y)]
var all_ids = [0,1,2,3]
var all_profiles = ["Slifos","Xeto","POULET","Yoxams","Baptoufs","Lila"]
@onready var all_slot = [$Slot,$Slot2,$Slot3,$team_button,$friendlyfire_button]
var friendlyfire := false
var limit_bot = 359.0
var limit_top = -359.0
var limit_left= -638.0
var limit_right= 638.0
var teamplay := false
const SELECTION_THEME ="res://Menu/Selection/sound/selection_theme.mp3"
@onready var all_cadre = [$Cadre1,$Cadre2,$Cadre3,$Cadre4]

@onready var team_mode: AudioStreamPlayer2D = $team_mode

const TEAM_ON = preload("res://Menu/Selection/sound/team_on.wav")
const TEAM_OFF = preload("res://Menu/Selection/sound/team_off.wav")

signal SWAP_MODE
signal SWAP_PSEUDO
signal SWAP_FRIENDLY
func _ready():
	SWAP_MODE.connect(func():$team_button.change())
	SWAP_FRIENDLY.connect(func():$friendlyfire_button.change())
func _process(delta: float) -> void:
	if len(all_id)>=2:
		var is_ready = true
		var team_diff = false
		var old_team
		for i in range(len(all_id)-1):
			if not all_id[i].is_ready or not all_id[i+1].is_ready:
				is_ready = false
			if teamplay and all_id[i].team!=all_id[i+1].team:
				team_diff=true
			if not teamplay:
				team_diff=true
			
		if is_ready and team_diff:
			
			
			
			var game = SceneManager.push_scene("res://Common/GameManager/Game.tscn")
			game.start_game(all_id,teamplay,friendlyfire)
			for id in all_id:
				id.press_b()
				id.a_pressed=true
			


func _input(event: InputEvent) -> void:
	if len(all_id)>=4 or event.device in all_devices:return
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_SPACE:
			all_id.append(identity.create(self,-1))
	if event is InputEventJoypadButton and event.pressed:
		if event.button_index == JOY_BUTTON_A :
			all_id.append(identity.create(self,event.device))
			
func swap_mode():
	
	teamplay = not teamplay

	for id in all_id:
		id.emit_signal("COLOR_CHANGED")
	emit_signal("SWAP_MODE")
	if teamplay:$friendlyfire_button.visible=true;team_mode.stream = TEAM_ON
		
	else:$friendlyfire_button.visible=false;team_mode.stream = TEAM_OFF
	
	team_mode.play()
			
func swap_friendly():
	friendlyfire = not friendlyfire
	emit_signal("SWAP_FRIENDLY")
	
func play_music():
	MusicManager.play_music(SELECTION_THEME)
