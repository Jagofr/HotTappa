extends CanvasLayer

signal start_game


func _ready():
	$MessageBox.hide()
	pass # Replace with function body.


#func _process(delta):
#	pass

func showMessage(msg:String , time:int):
	$MessageBox/Message.text = msg
	$MessageBox/MessageTimer.wait_time = time
	$MessageBox/MessageTimer.start()
	$MessageBox.show()
	pass

func _on_QuitButton_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_MessageTimer_timeout():
	$MessageBox.hide()
	pass # Replace with function body.


func _on_HighScoreButton_pressed():
	showMessage("Feature Not Available", 2)
	pass # Replace with function body.


func _on_MultiplayerButton_pressed():
	showMessage("Feature Not Available", 2)
	pass # Replace with function body.


func _on_PlayButton_pressed():
	for child in $".".get_children():
		child.hide()
	emit_signal("start_game")
	pass # Replace with function body.
