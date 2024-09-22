extends CharacterBody2D

class_name Bullet

var bulletPool: BulletPool

func _init(assignedBulletPool: BulletPool = null):
	if assignedBulletPool != null:
		bulletPool = assignedBulletPool

# if the bullet leaves the screen or collides with an enemy
func _bullet_done():
	bulletPool.emit(self)

func _process(delta: float) -> void:
	self.rotation += 0.5
	move_and_slide()
