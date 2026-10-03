extends Node2D
@onready var cd_switch: TextureProgressBar = $cd_switch
@onready var panel: Panel = $Panel

func assignate(changed,cd):
	changed.connect(func(cd):has_changed(cd))
	cd_switch.value = cd
	cd_switch.max_value = cd
	pass
func has_changed(cd):
	cd_switch.value = cd_switch.max_value-cd
	if cd_switch.value>=cd_switch.max_value:
		
		panel.visible = true
	else:panel.visible=false
