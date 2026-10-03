extends Node
class_name STATUS

var own
var duration
var time
func enter(): pass

func update(_delta):pass

func exit(): pass

func locks_movements():return false
func locks_actions():return false	
func locks_projections():return false
func is_invincible():return false
func get_speed():return 1
func get_vulnerable():return 1
func locks_status():return false
func get_gravite():return 1
func locks_jump():return false
