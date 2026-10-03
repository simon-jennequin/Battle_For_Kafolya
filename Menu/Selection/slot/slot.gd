extends Button
class_name SLOT
@export var code_perso:String
const CADRE_BREEZ = preload("res://Menu/Selection/slot/cadre_breez.png")
const CADRE_CHOBUSHI = preload("res://Menu/Selection/slot/cadre_chobushi.png")
const CADRE_PEACEGUIN = preload("res://Menu/Selection/slot/cadre_peaceguin.png")
@onready var animation: AnimatedSprite2D = $animation
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D





func _ready() -> void:
	match code_perso:
		"breez":animation.play("breez")
		"chobushi":animation.play("chobushi")
		"peaceguin":animation.play("peaceguin")
	




	
func cursor_interact(id):
	if len(id.persos)<2 and code_perso not in id.persos:
		id.persos.append(code_perso)
		id.cadre.spawn_chara()
		print("ajout du perso", code_perso)

		
