extends CanvasLayer

signal button_play
signal button_highscore
signal message_close

enum Difficulty {EASY, SCALED, HARD}

signal start_game(d)


func _ready():
	$MessageBox.hide()
	pass # Replace with function body.


#func _process(delta):
#	pass
		
func showMessage(msg:String , time:int, closeable:bool):
	if(closeable):
		$MessageBox/CloseButton.show()
		$MessageBox/CloseButton.disabled = false
	else:
		$MessageBox/CloseButton.hide()
		$MessageBox/CloseButton.disabled = true
	
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
	emit_signal("button_highscore")


func _on_MultiplayerButton_pressed():
	showMessage("Feature Not Available", 2, true)
	pass # Replace with function body.


func _on_PlayButton_pressed():
	emit_signal("button_play")


func _on_CloseButton_pressed():
	$MessageBox/MessageTimer.stop()
	$MessageBox.hide()
	pass # Replace with function body.
