extends Node
class_name identity
var selection
var manette
var pseudo
var persos = []
var color

var team
var cursor
var cadre
var is_ready = false
var score = 0
var id
var index 
var a_pressed:=false
var b_pressed:=false
var x_pressed:=false
var y_pressed:=false
var show_pseudo:=false
var shoulder_pressed:=false
var start_position:=Vector2(0,0)
var all_pseudo = []
const SPEED_CURSOR = 1600
var b0 = 0


signal IS_READY
signal NOT_READY
signal COLOR_CHANGED


static func simulate(new_id,new_persos,new_color,new_team,new_pseudo):
	var inst = preload("res://Menu/Selection/identity.gd").new()
	inst.pseudo = new_pseudo
	inst.manette = new_id
	inst.color = new_color
	inst.team = new_team
	inst.persos = new_persos
	return inst
	
static func create(selection_menu,new_id_controller):
	var inst = preload("res://Menu/Selection/identity.gd").new()
	inst.selection = selection_menu
	inst.manette = new_id_controller
	selection_menu.all_devices.append(new_id_controller)
	inst.take_pseudo()
	inst.take_color()
	inst.take_id()
	inst.take_team()
	inst.cursor = CURSOR_SELECTION.create(inst,selection_menu)
	inst.cursor.own = inst
	inst.cursor.global_position = Vector2.ZERO
	selection_menu.add_child(inst.cursor)
	selection_menu.add_child(inst)
	
	inst.cadre = selection_menu.all_cadre[inst.id].start(inst,selection_menu)
	inst.emit_signal("COLOR_CHANGED")
	
	
	return inst
func destroy():
	var found = false
	var i = 0
	while i<len(selection.all_id) and not found:
		if selection.all_id[i]==self:
			selection.all_devices.remove_at(i)
			selection.all_id.remove_at(i)
			
			found = true
		i+=1
	for y in range(len(cadre.chara)):
		cadre.dispawn_chara()
	cursor.destroy()
	selection.all_colors.insert(0,color)
	selection.all_ids.insert(0,id)
	selection.all_profiles.insert(0,pseudo)
	
	cadre.cancel()
	queue_free()
func take_pseudo():
	pseudo = selection.all_profiles[0]
	selection.all_profiles.remove_at(0)
func take_color():
	if color==null:
		color = selection.all_colors[0]
		selection.all_colors.remove_at(0)
func take_id():
	id = selection.all_ids[0]
	selection.all_ids.remove_at(0)
func take_team():
	team= id%2+1
func print_pseudo():
	
	pass	
func change_color(sens):
	if not selection.teamplay:
		if len(selection.all_colors)==0:return
		var old_color = color
		if sens>0:
			color = selection.all_colors[-1]
			selection.all_colors.remove_at(selection.all_colors.size()-1)
			selection.all_colors.insert(0,old_color)
		else:
			color = selection.all_colors[0]
			selection.all_colors.remove_at(0)
			selection.all_colors.append(old_color)
	else:
		team = (team+1)%3
		if team==0:team=1
			
			
	
	emit_signal("COLOR_CHANGED")
	
func change_pseudo(new_pseudo):
	selection.all_profiles.insert(0,pseudo)
	pseudo = new_pseudo
	cadre.label.text = new_pseudo
	cursor.label.text = new_pseudo
	for i in range(len(selection.all_profiles)):
		if selection.all_profiles[i]==new_pseudo:
			selection.all_profiles.remove_at(i)
			selection.emit_signal("SWAP_PSEUDO")
			return
			
	
	
func move_cursor(x,y,delta):
	cursor.global_position += Vector2(x,y)*SPEED_CURSOR*delta
	if cursor.global_position.x<selection.limit_left:
		cursor.global_position.x = selection.limit_left
	elif cursor.global_position.x>selection.limit_right:
		cursor.global_position.x = selection.limit_right
		
	if cursor.global_position.y<selection.limit_top:
		cursor.global_position.y = selection.limit_top
	elif cursor.global_position.y>selection.limit_bot:
		cursor.global_position.y = selection.limit_bot
func press_b():
	if is_ready:
		is_ready=false
		emit_signal("NOT_READY")
	elif len(persos)>0:
		persos.remove_at(persos.size() - 1)
		cadre.dispawn_chara()
	
func press_a():
	var all_overlaps= []
	var cursor_rect = cursor.get_global_rect()
	
	
	
	for slot in selection.all_slot:
		if cursor_rect.intersects(slot.get_global_rect()):
			all_overlaps.append(slot)
	if show_pseudo:
		for pseudo_button in cadre.all_buttons:
			if cursor_rect.intersects(pseudo_button.get_global_rect()):
				all_overlaps.append(pseudo_button)
	if len(all_overlaps)==1:
		all_overlaps[0].cursor_interact(self)
		return
	
	var cursor_center = cursor_rect.get_center()
	var min=null
	var the_one = null
	for overlaps in all_overlaps:
		if min==null or cursor_center.distance_to(overlaps.get_global_rect().get_center())<min:
			min = cursor_center.distance_to(overlaps.get_global_rect().get_center())
			the_one = overlaps
	if the_one!=null:the_one.cursor_interact(self)
	if not is_ready and len(persos)==2 and len(all_overlaps)==0:
		is_ready=true
		emit_signal("IS_READY")
func press_x():
	
	if not show_pseudo:
		cadre.print_pseudo()
		
	else:
		cadre.unprint_pseudo()
	show_pseudo = not show_pseudo

func _process(delta: float) -> void:
	
	var dir = Vector2(
		Input.get_joy_axis(manette,JOY_AXIS_LEFT_X),
		Input.get_joy_axis(manette,JOY_AXIS_LEFT_Y)
	)
	
	if abs(dir.x)>0.2:
		move_cursor(dir.x,0,delta)
	if abs(dir.y)>0.2:
		move_cursor(0,dir.y,delta)

	if Input.is_joy_button_pressed(manette, JOY_BUTTON_A) and not a_pressed:
		press_a()
		a_pressed = true
	elif not Input.is_joy_button_pressed(manette, JOY_BUTTON_A):
		a_pressed = false
		
	if Input.is_joy_button_pressed(manette, JOY_BUTTON_B) and not b_pressed:
		press_b()
		b_pressed = true
		b0 = Time.get_ticks_msec()
	elif not Input.is_joy_button_pressed(manette, JOY_BUTTON_B):
		b_pressed = false
	elif Input.is_joy_button_pressed(manette, JOY_BUTTON_B) and b_pressed and Time.get_ticks_msec()-b0>500:
		destroy()
		
	if Input.is_joy_button_pressed(manette, JOY_BUTTON_X) and not x_pressed:
		press_x()
		x_pressed = true
	elif not Input.is_joy_button_pressed(manette, JOY_BUTTON_X):
		x_pressed = false
		
	if Input.is_joy_button_pressed(manette,JOY_BUTTON_LEFT_SHOULDER) and not shoulder_pressed:
		shoulder_pressed = true
		change_color(-1)
	elif Input.is_joy_button_pressed(manette,JOY_BUTTON_RIGHT_SHOULDER) and not shoulder_pressed:
		shoulder_pressed = true
		change_color(1)
	elif not (Input.is_joy_button_pressed(manette,JOY_BUTTON_RIGHT_SHOULDER) or Input.is_joy_button_pressed(manette,JOY_BUTTON_LEFT_SHOULDER)):
		shoulder_pressed = false
	if Input.is_joy_button_pressed(manette, JOY_BUTTON_Y) and not y_pressed:
		
		selection.swap_mode()
		y_pressed = true
	elif not Input.is_joy_button_pressed(manette, JOY_BUTTON_Y):
		y_pressed = false
	
	
	
		
	
