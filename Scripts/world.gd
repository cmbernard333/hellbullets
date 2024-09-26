extends Node2D

@onready var health_text: Label = get_node("WorldUI/Label")
@onready var player: PlayerCharacter = get_node("Player")
@onready var player_health: int

func _on_player_death() -> void:
	pass
	
func _on_player_damage(damage: int) -> void:
	player_health = max(0, player_health - damage)
	health_text.text = str('Health: ', player_health)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.on_player_death.connect(_on_player_death)
	SignalBus.on_player_damage.connect(_on_player_damage)
	player_health = player.currHp 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
