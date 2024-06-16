extends Node

@export var mob_scene: PackedScene
@export var anon_dead_scene: PackedScene
signal win
var score
var win_or_not = 0
var reward_or_not = 0
enum bgm
{
	春日影,
	壱雫空,
	詩超絆,
	迷星叫,
	無路矢,
	影色舞
}
var current_bgm = bgm.春日影

func _ready():
	$HUD/BgmName.hide()
	#new_game()

func _process(delta):
	pass

func game_over():
	add_and_queue_dead_player()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	bgm_stop()
	$DeathSound.play()
	$SaveLoad.game_save()
	$SaveLoad.game_load()
	$HUD.updata_score(score)
	
func game_win():
	$Player.win_game()
	win_or_not = 1
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_win()
	bgm_stop()
	$WinSound.play()
	$SaveLoad.game_save()
	$SaveLoad.game_load()
	$HUD.updata_score(score)

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.updata_score(score)
	$HUD.show_message("准备开始")
	get_tree().call_group("mobs", "queue_free")
	bgm_play()
	
func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(100.0, 250.0), 0.0)
	var different_v
	if score <= 60:
		different_v = Vector2(score/2, 0).rotated(direction)
	elif score > 60 && score <= 120:
		different_v = Vector2(score / 1.2, 0).rotated(direction)
		var r_rate02 = randi_range(0,3)
		if r_rate02 == 1 || r_rate02 == 2:
			add_mob_01()
	else:
		different_v = Vector2(log(score) * 20, 0).rotated(direction)
		for i in range(1,(100 + score) / 100):
			add_mob_01()
	mob.linear_velocity = velocity.rotated(direction) + different_v
	var r_rate = randi_range(0,100)
	if r_rate == 0:
		mob.linear_velocity *= 1.1
	elif r_rate == 1:
		mob.linear_velocity *= log(score / 90 + 3)
	elif r_rate == 2:
		mob.linear_velocity *= 0.75
	elif r_rate == 3:
		mob.linear_velocity = Vector2(350, 0).rotated(direction)
	elif r_rate == 4:
		mob.linear_velocity *= log(score / 90 + 3)
	add_child(mob)
	
	
func add_mob_01():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	var different_v
	different_v = Vector2(log(score) * 20, 0).rotated(direction)
	mob.linear_velocity = velocity.rotated(direction) + different_v
	add_child(mob)

func add_and_queue_dead_player():
	var dead_anon = anon_dead_scene.instantiate()
	dead_anon.position = $Player.position
	add_child(dead_anon)
	await get_tree().create_timer(2.5).timeout
	dead_anon.queue_free()

func _on_score_timer_timeout():
	#score += 20
	score += 1
	$HUD.updata_score(score)
	if score >= 90 && win_or_not <= 0:
		game_win()
	if score >= 130 && reward_or_not <= 0:
		reward_or_not = 1
		$HUD.show_reward()

func _on_start_timer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()

func _on_hud_change_bgm():
	if current_bgm >= 5 || current_bgm < 0:
		current_bgm = 0
	else:
		current_bgm += 1;
	music_change()

func music_change():
	if current_bgm == bgm.春日影:
		bgm_name_change("春日影")
	elif current_bgm == bgm.壱雫空:
		bgm_name_change("壱雫空")
	elif current_bgm == bgm.詩超絆:
		bgm_name_change("詩超絆")
	elif current_bgm == bgm.迷星叫:
		bgm_name_change("迷星叫")
	elif current_bgm == bgm.無路矢:
		bgm_name_change("無路矢")
	elif current_bgm == bgm.影色舞:
		bgm_name_change("影色舞")
	else:
		bgm_name_change("春日影")

func bgm_name_change(bgm_name):
	$HUD/BgmName.text = bgm_name
	$HUD/BgmName.show()
	$MusicChangeTimer.start()

func bgm_play():
	if current_bgm == bgm.春日影:
		$Bgms/music01.play()
	elif current_bgm == bgm.壱雫空:
		$Bgms/music02.play()
	elif current_bgm == bgm.詩超絆:
		$Bgms/music03.play()
	elif current_bgm == bgm.迷星叫:
		$Bgms/music04.play()
	elif current_bgm == bgm.無路矢:
		$Bgms/music05.play()
	elif current_bgm == bgm.影色舞:
		$Bgms/music06.play()
	else:
		$Bgms/music01.play()

func bgm_stop():
		$Bgms/music01.stop()
		$Bgms/music02.stop()
		$Bgms/music03.stop()
		$Bgms/music04.stop()
		$Bgms/music05.stop()
		$Bgms/music06.stop()

func _on_music_change_timer_timeout():
	$HUD/BgmName.hide()
