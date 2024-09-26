extends CharacterBody2D

class_name PlayerCharacter

@export var maxHp: int = 3
@export var speed: int = 120
@onready var anim: AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var bulletPool = get_node("BulletPool/Bullets")
@onready var bulletSpawn = get_node("BulletPool/BulletSpawn")

# current health
var currHp: int
# the direction we are facing
var direction: Vector2 = Vector2(0, 1)

enum State {ALIVE, DEAD}

var state: State = State.ALIVE

func take_damage(damage: int):
	currHp = max(0, currHp - damage)
	SignalBus.on_player_damage.emit(damage)
	if currHp == 0:
		state = State.DEAD
		
func _shoot_bullet(playerDir: Vector2, bulletSpeed: float = 120) -> void:
	if Input.is_action_just_pressed("shoot"):
		var bullet: Bullet = bulletPool.get_bullet()
		bullet.collider.disabled = false
		bullet.global_position = bulletSpawn.global_position
		bullet.velocity = playerDir * bulletSpeed
		bullet.show()

# process physics between frames; delta is the time between the last frame
func _physics_process(delta: float) -> void:
	if state == State.ALIVE:
		var inputDirection: Vector2 = Vector2(
		Input.get_axis("MoveLeft", "MoveRight"),
		Input.get_axis("MoveUp", "MoveDown")
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
	
	if state == State.DEAD:
		var sprite: Sprite2D = get_node("Sprite")
		sprite.hide()
		anim.show()
		anim.play("death")
		await anim.animation_finished
		queue_free()
		SignalBus.on_player_death.emit()

func _ready():
	currHp = maxHp
