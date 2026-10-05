extends ProgressBar

@export var cd_bar:ProgressBar



var last_visible
func assignate(color,signal_changed,perso,spell,cd,cd_max,is_primary):
	signal_changed.connect(func(perso,spell,cd,cd_max,is_primary):changed(perso,spell,cd,cd_max,is_primary))
	changed(perso,spell,cd,cd_max,is_primary)
	var stylefill = cd_bar.get_theme_stylebox("fill").duplicate()
	if not SceneManager.current.teamplay:
		match color:
			"red":stylefill.bg_color = Color(0.6,0,0)
			"blue":stylefill.bg_color = Color(0,0,0.6)
			"green":stylefill.bg_color = Color(0,0.6,0)
			"yellow":stylefill.bg_color = Color(0.6,0.6,0)
	else:
		match perso.team:
			1:stylefill.bg_color = Color(0,0,0.6)
			2:stylefill.bg_color = Color(0.6,0,0)
	cd_bar.add_theme_stylebox_override("fill",stylefill)
func changed(perso,spell,cd,cd_max,is_primary):
	if last_visible!=null:last_visible.visible = false
	cd_bar.get_node(perso.nom+str(spell)).visible=true
	last_visible = cd_bar.get_node(perso.nom+str(spell))
	cd_bar.value = cd_max-cd
	cd_bar.max_value = cd_max
	
	if cd_bar.value>=cd_bar.max_value:
		if is_primary:modulate.a = 0.75
		else:modulate.a = 0.0
	else:modulate.a = 0.6
		
		
	
	
