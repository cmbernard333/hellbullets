extends ProgressBar

signal on_health_update(currHp: int, totalHp: int)

func _on_health_update(currHp: int, totalHp: int):
	self.value = float(currHp) / float(totalHp)
	
func _ready():
	on_health_update.connect(_on_health_update)
	self.value = 1
