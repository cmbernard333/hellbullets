extends Node

func setup_animation_frame(sprite: Sprite2D, inputDir: Vector2) -> void:
	if inputDir.x > 0:
		sprite.frame = 1
		sprite.flip_h = false
	elif inputDir.x < 0:
		sprite.frame = 1
		sprite.flip_h = true
	elif inputDir.y < 0:
		sprite.frame = 2
	elif inputDir.y > 0:
		sprite.frame = 0

func setup_animation_frame_flip(sprite: Sprite2D, inputDir: Vector2) -> void:
	if inputDir.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
