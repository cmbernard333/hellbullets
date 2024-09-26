extends CharacterBody2D

class_name Enemy

@export var enemyType: EnemyType
@export var player: PlayerCharacter

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collisionShape: CollisionShape2D = get_node("CollisionShape2D")
@onready var progressBar: ProgressBar = get_node("ProgressBar")
@onready var anim: AnimatedSprite2D = get_node("AnimatedSprite2D")

var direction: Vector2
var is_alive: bool
var currentHp: int
var pool: EnemyPool

signal on_hit(damage: int)

enum State {ALIVE, DYING, INACTIVE}

var state: State = State.ALIVE

# disabling an enemy effectively makes them dead, but is useful for pooling.
func die():
	self.state = State.DYING
	velocity = Vector2.ZERO
	collisionShape.set_deferred("disabled", true)

func live():
	self.currentHp = enemyType.maxHp
	progressBar.health_update(currentHp, enemyType.maxHp)
	assert(progressBar.value == 1, "health must be max on live() time")
	sprite.show()
	progressBar.show()
	anim.hide()
	self.state = State.ALIVE
	self.visible = true

func take_damage(damage: int):
	currentHp = max(0, currentHp - damage)
	progressBar.on_health_update.emit(currentHp, enemyType.maxHp)
	if currentHp == 0:
		self.die()
			
# getting hit by things (mostly bullets)
func _on_hit(damage: int):
	take_damage(damage)

# colliding with the player
func _on_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(1)

func _ready() -> void:
	on_hit.connect(_on_hit)
	# set texture
	sprite.texture = enemyType.texture
	# set the max hp
	currentHp = enemyType.maxHp
	# if you are marked as invisible, you shouldn't collide with anyone
	if not visible:
		collisionShape.disabled = true

func _physics_process(delta: float) -> void:
	if state == State.ALIVE and player != null:
		collisionShape.disabled = false
		direction = (player.global_position - self.global_position).normalized()
		
		SpriteUtils.setup_animation_frame_flip(get_node("Sprite2D"), direction)
		
		velocity = enemyType.speed * direction
		move_and_slide()
	
	if state == State.DYING:
		sprite.hide()
		progressBar.hide()
		anim.show()
		anim.play("death")
		await anim.animation_finished
		anim.hide()
		pool.reset_enemy(self)
		
