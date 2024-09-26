extends CharacterBody2D

class_name Bullet

@export var bulletDamage: int = 25
@onready var collider: CollisionShape2D = get_node("Collider/ColliderShape")

var pool: BulletPool

func _reset():
	collider.set_deferred("disabled", true)
	if pool != null:
		pool.reset_bullet(self)
	else:
		self.queue_free.call_deferred()

func _process(delta: float) -> void:
	self.rotation += 0.1
	move_and_slide()

# when something hits the area2d associated with this bullet
func _on_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		if self.visible and enemy.state == enemy.State.ALIVE:
			print("Bullet hit enemy")
			self._reset()
			body.take_damage(bulletDamage)
