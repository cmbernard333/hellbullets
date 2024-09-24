extends CharacterBody2D

class_name PlayerCharacter

@export var speed: float = 75.0
@onready var bulletPool: BulletPool = get_node("Bullets")
@onready var bullets = get_node("Bullets")
@onready var bulletSpawn = get_node("BulletSpawn")

# the direction we are facing
var direction: Vector2 = Vector2(0, 1)
		
func _shoot_bullet(playerDir: Vector2, bulletSpeed: float = 100) -> void:
	if Input.is_action_just_pressed("shoot"):
		var bullet: Bullet = bulletPool.get_bullet()
		bullet.global_position = bulletSpawn.global_position
		bullet.velocity = playerDir * bulletSpeed
		bullet.show()

# process physics between frames; delta is the time between the last frame
func _physics_process(delta: float) -> void:
	var inputDirection: Vector2 = Vector2(
	Input.get_axis("ui_left", "ui_right"),
	Input.get_axis("ui_up", "ui_down")
	).normalized()
	
	# setup the animation frame
	SpriteUtils.setup_animation_frame(get_node("Sprite"), inputDirection)
	
	# change velocity
	if inputDirection.x != 0:
		direction = inputDirection
	elif inputDirection.y != 0:
		direction = inputDirection
		
	# change the spawn point for the bullets
	bulletSpawn.position = direction * 10
	
	# shoot a bullet
	_shoot_bullet(direction)
	
	velocity = inputDirection * speed
	move_and_slide()
