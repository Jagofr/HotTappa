extends CanvasLayer

signal game_pause
signal game_end(time)
signal coin_tapped
signal move_stopped


# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.
	
func endGame(time):
	emit_signal("game_end", time)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	#Debug
#	if Input.is_key_pressed(KEY_SPACE):
#		$AliveTimer.start()
#	if Input.is_key_pressed(KEY_ENTER):
#		$AliveTimer.stop()
#	pass


func _on_TapCoin_tapped():	
	emit_signal("coin_tapped")
	pass


func _on_AliveTimer_timeout():
	$AliveTimer.stop()
	endGame(3)
	pass # Replace with function body.


func _on_PauseButton_pressed():
	emit_signal("game_pause")
	pass # Replace with function body.


func _on_TapCoin_movement_stopped():
	emit_signal("move_stopped")
