# A work-in-progress implementation of general purpose object pool
# TODO: needs a way to mark dead and alive objects correctly without relying on external factors
# TODO: sceneResetFunc is called by reset_object
# TODO: general purpose signal for an object being destroyed

class_name ObjectPool

var scene: PackedScene
var sceneInitFunc: Callable
var sceneResetFunc: Callable
var pool: Array
var poolSize: int
var parent: Node

func get_object() -> Node:
	for object in pool:
		# this should be generalized, but for now it works
		if not object.visible:
			return object
			
	var newObject = _add_object_to_pool()
	return newObject
	
func _init_pool():
	if scene == null:
		return
		
	for i in range(poolSize):
		_add_object_to_pool()
		
func reset_object(node: Node) -> void:
	# example
	#	bullet.position = Vector2(-1000,-1000)
	#	bullet.hide()
	self.sceneRestFunc.call(node)

func _add_object_to_pool() -> Node:
	var newObject = scene.instantiate()
	newObject.pool = self # set the bullet pool creator
	
	# bullet specific initialization
	#	newBullet.hide()
	#	add_to_group("Bullet", true)
	if sceneInitFunc != null:
		sceneInitFunc.call(newObject)
	
	pool.append(newObject)
	if parent != null:
		parent.add_child(newObject)
		
	return newObject

func _init(
		parent: Node, 
		scene: PackedScene, 
		poolSize: int, 
		sceneInitFunc: Callable, 
		sceneResetFunc: Callable
	):
	self.parent = parent
	self.scene = scene
	self.poolSize = poolSize
	self.sceneInitFunc = sceneInitFunc
	self.sceneResetFunc = sceneResetFunc
	
	_init_pool()
