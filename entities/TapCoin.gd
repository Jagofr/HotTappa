extends Area2D
signal tapped
signal movement_stopped

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TapCoin_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed and event.index == 0:
			emit_signal("tapped")


func _on_Animation_animation_finished(anim_name):
	emit_signal("movement_stopped")
