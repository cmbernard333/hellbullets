extends Node2D

class_name EnemyPool

@export var player: PlayerCharacter

@onready var timer: Timer = get_node("Timer")
@onready var spawn: Marker2D = get_node("Spawn")
@export var poolSize: int = 20

var enemyScene: PackedScene = preload("res://Scenes/enemy.tscn")

var pool: Array[Enemy] = []

# enemy_killed is the signal to say the enemy can be reset
signal enemy_killed(enemy: Enemy)

# when a enemy signals it has finished
func _on_enemy_done(enemy: Enemy):
	reset_enemy(enemy)

# add a new enemy to the pool
func _add_enemy_to_pool() -> Enemy:
	var newEnemy: Enemy = enemyScene.instantiate()
	newEnemy.hide()
	newEnemy.pool = self # set the enemy pool creator
	newEnemy.is_alive = false # have to set to alive; otherwise we can't get one
	newEnemy.player = player
	newEnemy.add_to_group("Enemy", true)
	pool.append(newEnemy)
	add_child(newEnemy) # note this calls _ready()
	return newEnemy

# check if we have any unused enemies; otherwise create a new one (grows to infinity)
func get_enemy() -> Enemy:
	for enemy in pool:
		if not enemy.is_alive:
			return enemy
	return null
	
func reset_enemy(enemy: Enemy) -> void:
	enemy.visible = false
	enemy.global_position = spawn.global_position
	
func _spawn_enemy() -> void:
	var enemy = get_enemy()
	print("Spawning enemy...")
	if enemy != null:
		enemy.global_position = spawn.global_position
		enemy.live()
		enemy.show()

func init() -> void:
	for i in range(poolSize):
		_add_enemy_to_pool()

func _ready() -> void:
	enemy_killed.connect(_on_enemy_done)
	init()
	timer.start()
