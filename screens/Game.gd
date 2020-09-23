extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gameRunning = false
var newPosition = Vector2()
var screenSize
var borderTop
var borderBottom
var borderLeft
var borderRight

var score
var aliveTime
var newTime
var timeText

func startGame():
	hideMainMenu()
	$MainMenu.showMessage("Get Ready", 5)
	newGame()
	showHUD()
	$HUD/TapCoin.input_pickable = false
	$HUD/PauseButton.disabled = true
	yield(get_tree().create_timer(5), "timeout")
	$HUD/PauseButton.disabled = false
	$HUD/TapCoin.input_pickable = true
	$HUD/AliveTimer.start()
	pass

func newGame():
	randomize()
	screenSize = $HUD/PlayArea.get_viewport_rect().size
	
	borderTop =  (screenSize.y - ($HUD/PlayArea.shape_owner_get_shape(0,0).extents.y * 2)) + 75
	borderBottom = screenSize.y - 75
	borderRight = screenSize.x - 75
	borderLeft = 75
	
	score = 0
	aliveTime = 5
	newTime = 0
	
	timeText = "Time Left: " + String(stepify($HUD/AliveTimer.time_left, 0.01)) + "s"
	
	$HUD/AliveTimer/TimeLeft.text = timeText
	
	$HUD/TimeLeftBar.value = aliveTime
	$HUD/TimeLeftBar.percent_visible = false
	$HUD/AliveTimer.wait_time = $HUD/TimeLeftBar.value
	
	newPosition = Vector2(rand_range(borderLeft, borderRight), rand_range(borderTop, borderBottom))
	$HUD/TapCoin.position = newPosition
	gameRunning = true
	pass
	
func endGame(time):
	$HUD/AliveTimer.stop()
	$HUD/TapCoin.hide()
	yield(get_tree().create_timer(time), "timeout")
	hideHUD()
	if $PauseMenu.visible:
		$PauseMenu.hide()
		$PauseMenu/ResumeButton.disabled = false
	showMainMenu()
	pass
	
func toMainMenu():
	$PauseMenu/ResumeButton.disabled = true
	endGame(1)
	pass
	
func pauseGame():
	$HUD/TapCoin.input_pickable = false
	$HUD/PauseButton.disabled = true
	$PauseMenu.show_on_top = true
	$PauseMenu.show()
	$HUD/AliveTimer.paused = true
	pass

func resumeGame():
	$PauseMenu.hide()
	$HUD/AliveTimer.paused = false
	$HUD/TapCoin.input_pickable = true
	$HUD/PauseButton.disabled = false
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$HUD/TapCoin.hide()
	hideHUD()
	$PauseMenu.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(gameRunning):
		$HUD/TimeLeftBar.value = $HUD/AliveTimer.time_left
		timeText = "Time Left: " + String(stepify($HUD/AliveTimer.time_left, 0.1)) + "s"
		$HUD/AliveTimer/TimeLeft.text = timeText
	
		if $HUD/AliveTimer.time_left == 0:
			timeText = "Game Over"
			$HUD/AliveTimer/TimeLeft.text = timeText
	pass

func hideHUD():
	$HUD/AliveTimer/TimeLeft.hide()
	$HUD/PlayArea.hide()
	$HUD/TapCoin.hide()
	$HUD/TimeLeftBar.hide()
	$HUD/ScoreLabel.hide()
	$HUD/PauseButton.hide()
	pass

func showHUD():
	$HUD/AliveTimer/TimeLeft.show()
	$HUD/PlayArea.show()
	$HUD/TapCoin.show()
	$HUD/TimeLeftBar.show()
	$HUD/ScoreLabel.show()
	$HUD/PauseButton.show()
	pass
	
func hideMainMenu():
	$MainMenu/ColorRect.hide()
	$MainMenu/GameName.hide()
	$MainMenu/PlayButton.hide()
	$MainMenu/HighScoreButton.hide()
	$MainMenu/MultiplayerButton.hide()
	$MainMenu/MusicToggle.hide()
	$MainMenu/QuitButton.hide()

func showMainMenu():
	$MainMenu/ColorRect.show()
	$MainMenu/GameName.show()
	$MainMenu/PlayButton.show()
	$MainMenu/HighScoreButton.show()
	$MainMenu/MultiplayerButton.show()
	$MainMenu/MusicToggle.show()
	$MainMenu/QuitButton.show()


func _on_HUD_coin_tapped():
	score += 1
	newTime = clamp($HUD/AliveTimer.time_left + rand_range(0.2, 0.79), 0, 25)
#	$AliveTimer.stop()
	$HUD/AliveTimer.wait_time = float(newTime)
	$HUD/AliveTimer.start()
	$HUD/ScoreLabel.text = String(score)
	
	newPosition = Vector2(rand_range(borderLeft, borderRight), rand_range(borderTop, borderBottom))
	$HUD/TapCoin.position = newPosition
	pass # Replace with function body.
