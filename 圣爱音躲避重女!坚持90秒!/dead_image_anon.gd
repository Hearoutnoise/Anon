extends Area2D


func _ready():
	var dead_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(dead_types[randi() % dead_types.size()])

func _process(delta):
	pass
