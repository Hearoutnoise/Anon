extends Node

@onready var game_main = $".."
@onready var HUD = $"../HUD"
var inttial_var = 0

func _ready():
	var executable_path = OS.get_executable_path()
	var parant_path = executable_path.get_base_dir()
	var save_path = parant_path.path_join("save.data")
	if FileAccess.file_exists(save_path):
		game_load()
		HUD.updata_score(game_main.score)
	else:
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_var(inttial_var)
		file.store_var(inttial_var)
		file.store_var(inttial_var)
		file.close()
		print("save_inttial_ready")

func _process(delta):
	pass

func game_save():
	var executable_path = OS.get_executable_path()
	var parant_path = executable_path.get_base_dir()
	var save_path = parant_path.path_join("save.data")
	var file = FileAccess.open(save_path, FileAccess.READ_WRITE)
	var temp_win_or_not = file.get_var()
	print(temp_win_or_not)
	var temp_score = file.get_var()
	print(temp_score)
	print(game_main.win_or_not)
	print(game_main.score)
	file.seek(0)
	file.store_var(game_main.win_or_not)
	if temp_score >= game_main.score:
		file.store_var(temp_score)
	else:
		file.store_var(game_main.score)
	file.store_var(game_main.reward_or_not)
	file.close()

func game_load():
	var executable_path = OS.get_executable_path()
	var parant_path = executable_path.get_base_dir()
	var save_path = parant_path.path_join("save.data")
	var file = FileAccess.open(save_path, FileAccess.READ)
	game_main.win_or_not = file.get_var()
	game_main.score = file.get_var()
	game_main.reward_or_not = file.get_var()
	file.close()

func check_file():
	var executable_path = OS.get_executable_path()
	var parant_path = executable_path.get_base_dir()
	var save_path = parant_path.path_join("save.data")
	var file = FileAccess.open(save_path, FileAccess.READ_WRITE)
	var temp_win_or_not = file.get_var()
	var temp_score = file.get_var()
	var temp_reward_or_not = file.get_var()
	file.seek(0)
	if (temp_win_or_not != 0 && temp_win_or_not != 1) || (temp_reward_or_not != 0 && temp_reward_or_not != 1):
		file.store_var(inttial_var)
		file.store_var(inttial_var)
		file.store_var(inttial_var)
	file.close()
