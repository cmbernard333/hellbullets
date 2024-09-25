extends CharacterBody2D

class_name Enemy

@export var enemyType: EnemyType
@export var player: PlayerCharacter

@onready var deathMarker: Sprite2D = get_node("DeathMarker")
@onready var collisionShape: CollisionShape2D = get_node("CollisionShape2D")

var direction: Vector2
var is_alive: bool
var currentHp: int
var pool: EnemyPool

signal on_hit(damage: int)

# disabling an enemy effectively makes them dead, but is useful for pooling.
func _die():
	self.is_alive = false
	deathMarker.visible = true
	collisionShape.disabled = true

func live():
	self.currentHp = enemyType.maxHp
	self.is_alive = true
	deathMarker.visible = false
	collisionShape.disabled = false

func take_damage(damage: int):
	print('Enemy ', self.get_instance_id(), ' took ', damage, ' damage')
	currentHp = min(0, currentHp - damage)
	if currentHp == 0:
		if pool == null:
			queue_free.call_deferred()
		else:
			self._die()
			pool.reset_enemy(self)
			
func _on_hit(damage: int):
	take_damage(damage)

func _ready() -> void:
	on_hit.connect(_on_hit)
	var sprite: Sprite2D = get_node("Sprite2D")
	
	# set texture
	sprite.texture = enemyType.texture
	
	# set the max hp
	currentHp = enemyType.maxHp

func _physics_process(delta: float) -> void:
	if is_alive and player != null:
		direction = (player.global_position - self.global_position).normalized()
		
		SpriteUtils.setup_animation_frame_flip(get_node("Sprite2D"), direction)
		
		velocity = enemyType.speed * direction
		move_and_slide()
