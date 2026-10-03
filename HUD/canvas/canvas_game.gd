extends CanvasLayer
@export var container:HBoxContainer
@onready var all_cadre = [$Control/HBoxContainer/Cadre_hud,$Control/HBoxContainer/Cadre_hud2,$Control/HBoxContainer/Cadre_hud3,$Control/HBoxContainer/Cadre_hud4]
@onready var ready_animation: AnimationPlayer = $ready/readyAnimation
@onready var go_animation: AnimationPlayer = $go/go_animation

@onready var ready_label: Label = $ready
@onready var go: Label = $go
@onready var ready_stream: AudioStreamPlayer2D = $readyStream
@onready var go_stream: AudioStreamPlayer2D = $go_stream




var is_finish = false

	
func start():
	is_finish = false
	ready_label.visible=true
	go.visible=false
	ready_animation.play("start")
	ready_stream.play()
func ending():
	
	ready_label.visible=false
	is_finish=true
	

func _on_ready_animation_animation_finished(anim_name: StringName) -> void:
	go_animation.play("start")
	go_stream.play()


func _on_go_animation_animation_finished(anim_name: StringName) -> void:
	ending()
