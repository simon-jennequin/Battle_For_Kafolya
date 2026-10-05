extends Node

var scene_stack: Array = []
var pause_menu_scene := preload("res://Menu/pause/pause_menu.tscn")
var pause_menu_instance: CanvasLayer
var is_paused := false
var current
var all_char = {"breez":preload("res://Entities/Breez/breez_entity.tscn"),"chobushi":preload("res://Entities/Chobushi/chobushi_entity.tscn"),"peaceguin":preload("res://Entities/Peaceguin/peaceguin_entity.tscn")}
@onready var scene_container :Node2D


func register_container(container: Node) -> void:
	scene_container = container
func push_scene(path: String) -> Node:
	if not scene_container:
		push_error("SceneManager n’a pas de container enregistré.")
		return null

	var new_scene = load(path).instantiate()
	scene_stack.append(new_scene)
	scene_container.add_child(new_scene)
	current = new_scene
	current.play_music()

	if len(scene_stack) > 1:
		scene_container.remove_child(scene_stack[-2])
	
	return new_scene
func get_camera():
	if scene_stack ==[]:return null
	return scene_stack[-1].camera
	

func pop_scene() -> void:
	if len(scene_stack) <= 1:
		
		return

	var current_scene = scene_stack.pop_back()
	current_scene.queue_free()
	
	var previous_scene = scene_stack[-1]
	scene_container.add_child(scene_stack[-1])
	current = scene_stack[-1]
	current.play_music()
func toggle_pause(id):
	
	
	

	if is_paused:
		resume_game()
		
	else:
		pause_game(id)
		


func pause_game(id):
	if is_paused:
		return
	

	get_tree().paused = true
	is_paused = true

	if not pause_menu_instance:
		pause_menu_instance = pause_menu_scene.instantiate()
		# Le menu aussi doit rester actif pendant la pause
		
		get_tree().root.add_child(pause_menu_instance)

	pause_menu_instance.show()
	pause_menu_instance.start(id)





func resume_game():
	if not is_paused:
		return
	get_tree().paused = false
	is_paused = false

	if pause_menu_instance:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
