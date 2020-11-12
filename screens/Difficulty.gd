extends CanvasLayer

signal set_difficult(difficulty)
signal closeDifficulty

enum Difficulty {EASY, SCALED, HARD}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Easy_pressed():
	emit_signal("set_difficult", Difficulty.EASY)


func _on_Normal_pressed():
	emit_signal("set_difficult", Difficulty.SCALED)


func _on_Hard_pressed():
	emit_signal("set_difficult", Difficulty.HARD)


func _on_Back_pressed():
	for child in $".".get_children():
		child.hide()
	emit_signal("closeDifficulty")
