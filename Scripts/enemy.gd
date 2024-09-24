extends CharacterBody2D

@export var enemyType: EnemyType
@export var player: PlayerCharacter

var start_pos: Vector2
var direction: Vector2
var is_alive: bool = true
var currentHp: int

signal on_hit(damage: int)

func take_damage(damage: int):
	currentHp = min(0, currentHp - damage)
	if currentHp == 0:
		queue_free.call_deferred()

func _on_hit(damage: int) -> void:
	take_damage(damage)

func _ready() -> void:
	# setup the hit signal
	on_hit.connect(_on_hit)
	
	start_pos = global_position
	var sprite: Sprite2D = get_node("Sprite2D")
	var collisionShape2D: CollisionShape2D = get_node("CollisionShape2D")
	# set texture
	sprite.texture = enemyType.texture
	# set collision shape based on sprite size
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(sprite.get_rect().size * 0.95)
	collisionShape2D.shape = rect
	# set the max hp
	currentHp = enemyType.maxHp

func _physics_process(delta: float) -> void:
	if is_alive:
		direction = (player.global_position - self.global_position).normalized()
		
		SpriteUtils.setup_animation_frame_flip(get_node("Sprite2D"), direction)
		
		velocity = enemyType.speed * direction
		move_and_slide()
