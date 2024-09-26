extends Node2D

class_name EnemyPool

@export var player: PlayerCharacter

@onready var timer: Timer = get_node("Timer")
@export var poolSize: int = 20

var enemyScene: PackedScene = preload("res://Scenes/enemy.tscn")

var pool: Array[Enemy] = []

# enemy_killed is the signal to say the enemy can be reset
signal enemy_killed(enemy: Enemy)

# check if we have any unused enemies; otherwise create a new one (grows to infinity)
func get_enemy() -> Enemy:
	for enemy in pool:
		if enemy.state == enemy.State.INACTIVE:
			return enemy
	return null

func init() -> void:
	for i in range(poolSize):
		_add_enemy_to_pool()
	
func reset_enemy(enemy: Enemy) -> void:
	enemy.state = enemy.State.INACTIVE
	enemy.global_position = Vector2(-1000, -1000)

# add a new enemy to the pool
func _add_enemy_to_pool() -> Enemy:
	var enemy: Enemy = enemyScene.instantiate()
	enemy.hide()
	enemy.pool = self # set the enemy pool creator
	enemy.state = enemy.State.INACTIVE
	enemy.player = player
	enemy.add_to_group("Enemy", true)
	pool.append(enemy)
	add_child(enemy) # note this calls _ready()
	return enemy

func _ready() -> void:
	init()
	timer.start()

func _random_position() -> Vector2:
	return Vector2(randi_range(-50, 50), randi_range(-50, 50))

# after the timer times out, it calls this function
func _spawn_enemy() -> void:
	var enemy = get_enemy()
	if enemy != null:
		enemy.global_position = self.global_position + _random_position()
		enemy.live()
		assert(enemy.progressBar.value == 1, "Enemy health must be max!")
