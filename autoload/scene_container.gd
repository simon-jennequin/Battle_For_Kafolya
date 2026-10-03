extends Node2D

func _ready() -> void:
	
	# On donne le conteneur au SceneManager autoload
	SceneManager.register_container(self)
	SceneManager.push_scene("res://Menu/Intro/Intro.tscn")
	#SceneManager.push_scene("res://Menu/selection/selection.tscn")
	#SceneManager.push_scene("res://Common/GameManager/Game.tscn")
	
	
