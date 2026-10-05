extends Button
class_name SLOT
@export var code_perso:String
@onready var animation: AnimatedSprite2D = $animation





func _ready() -> void:
	match code_perso:
		"breez":animation.play("breez")
		"chobushi":animation.play("chobushi")
		"peaceguin":animation.play("peaceguin")
	




	
func cursor_interact(id):
	if len(id.persos)<2 and code_perso not in id.persos:
		id.persos.append(code_perso)
		id.cadre.spawn_chara()

		
