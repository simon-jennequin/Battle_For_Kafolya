extends Node

class_name STATE
var own
var nom:=""
const FREEZ = preload("res://Entities/Peaceguin/freez/freez.tscn")

func setup():
	pass


func init(perso):
	own = perso



func enter(_prev):
	pass
	
func update(_delta):
	pass
func exit(next):
	if next!="":own.current = own.states[next]
func is_busy():
	return false
	
	
	
func _flip():
	if own.direction<0:
		own.animation.flip_h=false
	else:
		own.animation.flip_h=true
	
func _flip_aim():
	if own.aimX<0:
		own.animation.flip_h=false
	else:
		own.animation.flip_h=true
	
		
func locks_movements():return false
func locks_actions():return false
func locks_jump():return false
func locks_projections():return false
func is_invincible():return false
func get_speed():return 1
func get_vulnerable():return 1
func locks_status():return false
func get_gravite():return 1
