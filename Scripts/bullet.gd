extends CharacterBody2D

class_name Bullet

@export var bulletDamage: int = 25

var pool: BulletPool

func _reset():
	if pool != null:
		pool.reset_bullet(self)
	else:
		self.queue_free.call_deferred()

func _init(assignedBulletPool: BulletPool = null):
	if assignedBulletPool != null:
		self.pool = assignedBulletPool

# if the bullet leaves the screen or collides with an enemy
func _bullet_done():
	pool.emit(self)

func _process(delta: float) -> void:
	self.rotation += 0.5
	move_and_slide()

# when something hits the area2d associated with this bullet
func _on_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		if self.visible and body.is_alive and body.visible:
			print('Bullet hit enemy')
			body.take_damage(bulletDamage)
			self._reset()
