extends Node

var gameRunning = false
var gameDiff
var newPosition = Vector2()
var screenSize
var borderTop
var borderBottom
var borderLeft
var borderRight
var scoresFilePath := "user://data/scores.txt"

const vibTime = 45

var scoresdatabase

var scores := [
	[],
	[],
	[]
]

var score
var aliveTime
var newTime
var timeText

const lRandTime = 0.33
var uRandTime

enum GameMode {VS, LMS}
enum Difficulty {EASY, SCALED, HARD}

func _ready():
	
	scoresdatabase = Directory.new()
	if scoresdatabase.dir_exists("user://data") == false:
		print("No Data Folder, Creating New")
		scoresdatabase.open("user://")
		scoresdatabase.make_dir("data")
	
	scoresdatabase = File.new()
	if scoresdatabase.file_exists(scoresFilePath) == false:
		print("No Scores File, Creating New")
		scoresdatabase.open(scoresFilePath, File.WRITE)
		scoresdatabase.seek(0)
		scoresdatabase.store_var(scores)
		scoresdatabase.close()
	else:
		print("Scores File Found, Loading")
		scoresdatabase.open(scoresFilePath, File.READ_WRITE)
		scoresdatabase.seek(0)
		var temp = scoresdatabase.get_var()
		scores = temp
		scoresdatabase.close()
	
	
	hideMenu("HUD")
	$HUD/PauseMenu.hide()
	hideMenu("Difficulty")
	hideMenu("HighScore")
	$HUD/TapCoin/Animation.stop()
	$MainMenu/VibrationTime.hide()

func _process(delta):
	if(gameRunning):
		$HUD/TimeLeftBar.value = $HUD/AliveTimer.time_left
		timeText = "Time Left: " + String(stepify($HUD/AliveTimer.time_left, 0.1)) + "s"
		$HUD/AliveTimer/TimeLeft.text = timeText
	
		if $HUD/AliveTimer.time_left == 0:
			timeText = "Game Over"
			$HUD/AliveTimer/TimeLeft.text = timeText

func startGame(difficulty):
	hideMenu("Main")
	$MainMenu.showMessage("Get Ready to start\ntapping the coin!", 5, false)
	newGame(difficulty)
	hideMenu("Difficulty")
	showMenu("HUD")
	$HUD/TapCoin.input_pickable = false
	$HUD/PauseButton.disabled = true
	yield(get_tree().create_timer(5), "timeout")
	$HUD/PauseButton.disabled = false
	$HUD/TapCoin.input_pickable = true
	$HUD/AliveTimer.start()

func saveScore(gameDifficulty, playerName, playerScore):
	scores[gameDifficulty].push_front(String($MainMenu/PlayerName.text + " - " + String(score)))
	
	scoresdatabase = File.new()
	scoresdatabase.open(scoresFilePath, File.WRITE_READ)
	scoresdatabase.store_var(scores)
	scoresdatabase.close()

func newGame(difficulty):
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
	gameDiff = difficulty
	

func endGame(time):
	saveScore(gameDiff, $MainMenu/PlayerName.text, score)
	
	$HUD/AliveTimer.stop()
	$HUD/TapCoin.hide()
	yield(get_tree().create_timer(time), "timeout")
	hideMenu("HUD")
	if $HUD/PauseMenu.visible:
		hideMenu("Pause")
		$HUD/PauseMenu/ResumeButton.disabled = false
	showMenu("Main")
	
func toMainMenu():
	$HUD/PauseMenu/ResumeButton.disabled = true
	endGame(1)
	
func pauseGame():
	showMenu("Pause")
	
func resumeGame():
	hideMenu("Pause")


func hideMenu(menuName):
	match menuName:
		"HUD":
			$HUD/AliveTimer/TimeLeft.hide()
			$HUD/PlayArea.hide()
			$HUD/TapCoin.hide()
			$HUD/TimeLeftBar.hide()
			$HUD/ScoreLabel.hide()
			$HUD/PauseButton.hide()
			$HUD/TapCoin.hide()

		"Main":
			$MainMenu/ColorRect.hide()
			$MainMenu/GameName.hide()
			$MainMenu/PlayButton.hide()
			$MainMenu/HighScoreButton.hide()
			$MainMenu/MultiplayerButton.hide()
			$MainMenu/MusicToggle.hide()
			$MainMenu/QuitButton.hide()
			$MainMenu/PlayerName.hide()

		"Pause":
			$HUD/PauseMenu.hide()
			$HUD/AliveTimer.paused = false
			$HUD/TapCoin.input_pickable = true
			$HUD/PauseButton.disabled = false

		"Difficulty":
			for child in $MainMenu/Difficulty.get_children():
				child.hide()
				
		"HighScore":
			for child in $MainMenu/HighScoreMenu.get_children():
				child.hide()

func init_highscores():
	
	var fntData = DynamicFontData.new()
	fntData.font_path = "res://resources/fonts/Bitstream Vera Sans Mono Oblique.ttf"
	fntData.antialiased = true
	var fnt = DynamicFont.new()
	fnt.font_data = fntData
	fnt.size = 20
	
	if scores[Difficulty.EASY].size() > 0:
		for entry in scores[Difficulty.EASY]:
			var ent = Label.new()
			ent.set("custom_fonts/font", fnt)
			ent.align = Label.ALIGN_CENTER
			ent.text = entry
			$MainMenu/HighScoreMenu/TabContainer/Easy.add_child(ent)
	else:
		var ent = Label.new()
		ent.set("custom_fonts/font", fnt)
		ent.align = Label.ALIGN_CENTER
		ent.text = "No Scores Yet"
		$MainMenu/HighScoreMenu/TabContainer/Easy.add_child(ent)
	
	if scores[Difficulty.SCALED].size() > 0:
		for entry in scores[Difficulty.SCALED]:
			var ent = Label.new()
			ent.set("custom_fonts/font", fnt)
			ent.align = Label.ALIGN_CENTER
			ent.text = entry
			$MainMenu/HighScoreMenu/TabContainer/Normal.add_child(ent)
	else:
		var ent = Label.new()
		ent.set("custom_fonts/font", fnt)
		ent.align = Label.ALIGN_CENTER
		ent.text = "No Scores Yet"
		$MainMenu/HighScoreMenu/TabContainer/Normal.add_child(ent)
	
	if scores[Difficulty.HARD].size() > 0:
		for entry in scores[Difficulty.HARD]:
			var ent = Label.new()
			ent.set("custom_fonts/font", fnt)
			ent.align = Label.ALIGN_CENTER
			ent.text = entry
			$MainMenu/HighScoreMenu/TabContainer/Hard.add_child(ent)
	else:
		var ent = Label.new()
		ent.set("custom_fonts/font", fnt)
		ent.align = Label.ALIGN_CENTER
		ent.text = "No Scores Yet"
		$MainMenu/HighScoreMenu/TabContainer/Hard.add_child(ent)

func destroy_highscores():
	for child in $MainMenu/HighScoreMenu/TabContainer/Easy.get_children():
		if child.name.match("Key"):
			continue
		else:
			child.queue_free()
	for child in $MainMenu/HighScoreMenu/TabContainer/Normal.get_children():
		if child.name.match("Key"):
			continue
		else:
			child.queue_free()
	for child in $MainMenu/HighScoreMenu/TabContainer/Hard.get_children():
		if child.name.match("Key"):
			continue
		else:
			child.queue_free()
		

func showMenu(menuName):
	match menuName:
		"HUD":
			$HUD/AliveTimer/TimeLeft.show()
			$HUD/PlayArea.show()
			$HUD/TapCoin.show()
			$HUD/TimeLeftBar.show()
			$HUD/ScoreLabel.show()
			$HUD/PauseButton.show()
			$HUD/TapCoin.show()

		"Main":
			$MainMenu/ColorRect.show()
			$MainMenu/GameName.show()
			$MainMenu/PlayButton.show()
			$MainMenu/HighScoreButton.show()
			$MainMenu/MultiplayerButton.show()
			$MainMenu/MusicToggle.show()
			$MainMenu/QuitButton.show()
			$MainMenu/PlayerName.show()

		"Pause":
			$HUD/TapCoin.input_pickable = false
			$HUD/PauseButton.disabled = true
			$HUD/PauseMenu.show_on_top = true
			$HUD/PauseMenu.show()
			$HUD/AliveTimer.paused = true

		"Difficulty":
			if $MainMenu/PlayerName.text.empty():
				$MainMenu.showMessage("You need to set a name before starting", 10, true)
			elif $MainMenu/VibrationTime.text.empty():
				$MainMenu.showMessage("DEBUG: YOU NEED TO SET VIB_TIME", 10, true)
			else:
				for child in $MainMenu/Difficulty.get_children():
					child.show()
			
		"HighScore":
			for child in $MainMenu/HighScoreMenu.get_children():
				child.show()
			init_highscores()

func _on_HUD_coin_tapped():
	Input.vibrate_handheld(vibTime)
	score += 1
	
	match gameDiff:
		Difficulty.EASY:
			newTime = clamp($HUD/AliveTimer.time_left + rand_range(0.37, 0.62), 0, 25)
		Difficulty.SCALED:
			uRandTime = 0.62 - (0.001 * score)
			#uRandTime -= (0.0001 * score)
			if uRandTime < 0.42: 
				uRandTime = 0.42
			newTime = clamp($HUD/AliveTimer.time_left + rand_range(lRandTime, uRandTime), 0, 25)
			
		Difficulty.HARD:
			newTime = clamp($HUD/AliveTimer.time_left + rand_range(0.2, 0.47), 0, 25)
	
	$HUD/AliveTimer.wait_time = float(newTime)
	$HUD/AliveTimer.start()
	$HUD/ScoreLabel.text = String(score)
	
	var oldPosition = $HUD/TapCoin.position
	newPosition = Vector2(rand_range(borderLeft, borderRight), rand_range(borderTop, borderBottom))
	
	$HUD/TapCoin/Animation.get_animation("Movement").track_set_key_value(0,0, oldPosition)
	$HUD/TapCoin/Animation.get_animation("Movement").track_set_key_value(0,1, newPosition)
	$HUD/TapCoin/Animation.play("Movement", -0.1, 0.72)
	$HUD/TapCoin.translate(newPosition - oldPosition)
	$HUD/TapCoin.position = newPosition

func _on_MainMenu_button_play():
	showMenu("Difficulty")


func _on_Difficulty_closeDifficulty():
	hideMenu("Difficulty")


func _on_HUD_move_stopped():
	pass


func _on_HighScoreMenu_go_back():
	destroy_highscores()
	hideMenu("HighScore")


func _on_MainMenu_button_highscore():
	showMenu("HighScore")
