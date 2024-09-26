extends Node

class_name BulletPool

var bulletScene: PackedScene = preload("res://Scenes/bullet.tscn")
var poolSize: int = 20
var pool: Array[Bullet] = []

# bullet_done is the signal to say the bullet can be reset
signal bullet_done(bullet: Bullet)

# when a bullet signals it has finished
func _on_bullet_done(bullet: Bullet):
	reset_bullet(bullet)

# add a new bullet to the pool
func _add_bullet_to_pool() -> Bullet:
	var newBullet: Bullet = bulletScene.instantiate()
	newBullet.pool = self # set the bullet pool creator
	newBullet.hide()
	newBullet.add_to_group("Bullet", true)
	pool.append(newBullet)
	add_child(newBullet)
	return newBullet

# check if we have any unused bullets; otherwise create a new one (grows to infinity)
func get_bullet() -> Bullet:
	for bullet in pool:
		if not bullet.visible:
			return bullet
			
	var newBullet = _add_bullet_to_pool()
	return newBullet
	
func reset_bullet(bullet: Bullet) -> void:
	bullet.hide()
	bullet.velocity = Vector2(0, 0)
	bullet.global_position = get_parent().global_position

func _ready() -> void:
	bullet_done.connect(_on_bullet_done)
	for i in range(poolSize):
		_add_bullet_to_pool()
