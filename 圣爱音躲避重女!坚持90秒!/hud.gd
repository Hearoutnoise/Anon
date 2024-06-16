extends CanvasLayer
signal start_game
signal change_bgm
var win_or_not = 0
var reward_or_not = 0

func _ready():
	win_or_not = $"..".win_or_not
	reward_or_not = $"..".reward_or_not
	$RewardButton.hide()
	$RewardMessage.hide()
	if win_or_not != 1:
		$WinButton.hide()
	if reward_or_not != 1 && win_or_not == 1:
		$RewardMessage.show()
	if win_or_not == 1:
		$Message.text = "圣爱音正在享受胜利..."
		$Message.show()
		$StartButton.text = "试试无尽模式?"
		$Message.show()
		$WinButton.show()
	if reward_or_not == 1:
		$RewardButton.show()
		$RewardMessage.hide()
		
func _process(delta):
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("被重女抓到了(悲")
	await $MessageTimer.timeout
	if win_or_not <= 0:
		$Message.text = "圣爱音躲避重女!坚持90秒!"
	else:
		$Message.text = "圣爱音正在享受胜利..."
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	if win_or_not > 0:
		$WinButton.show()
	if reward_or_not <= 0 && win_or_not > 0:
		$RewardMessage.show()
	if reward_or_not > 0:
		$RewardButton.show()
		$RewardMessage.hide()
	$StartButton.show()
	$BgmChangeButton.show()
	
func show_game_win():
	win_or_not = 1
	show_message("爱音赢了!")
	await $MessageTimer.timeout
	$Message.text = "圣爱音正在享受胜利..."
	$Message.show()
	$StartButton.text = "试试无尽模式?"
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$WinButton.show()
	$BgmChangeButton.show()
	$RewardMessage.show()
	
func show_reward():
	reward_or_not = 1
	
func updata_score(score):
	$ScoreLabel.text = str(score)


func _on_start_button_pressed():
	$StartButton.hide()
	$WinButton.hide()
	$BgmChangeButton.hide()
	$RewardMessage.hide()
	$BgmName.hide()
	$RewardButton.hide()
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
	
func _on_win_button_pressed():
	OS.shell_open("https://www.bilibili.com/video/BV1Q64y1w7jm/?share_source=copy_web&vd_source=5047f14cee3b79bcfb66d58c38905d21")

func _on_bgm_change_button_pressed():
	change_bgm.emit()

func _on_reward_button_pressed():
	$RewardButton.disabled = true
	var executable_path = OS.get_executable_path()
	var parant_path = executable_path.get_base_dir()
	for i in range(1, 18):
		var save_name = "image" + str(i) + ".png"
		var load_name
		if i == 8 || i == 10 || i == 16:
			load_name = "0" + str(i) + ".png"
		else:
			load_name = "0" + str(i) + ".jpg"
		var save_path = parant_path.path_join(save_name)
		var texture = load("res://rewards/" + load_name)
		var image: Image = texture.get_image()
		image.save_png(save_path)
		OS.shell_open(save_path)
		await get_tree().create_timer(0.75).timeout
	$RewardButton.disabled = false
	
