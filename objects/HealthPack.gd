extends Sprite

onready var area = $Area2D

func _ready():
	area.connect("body_entered", self, "heal")

func heal(body):
	if not body is Player: return
	body.health += randi() % 5 + 3
	body.health = min(body.health, body.max_health)
	for turret in body.turrets:
		turret.health += randi() % 10 + 10
		turret.health = min(turret.health, turret.max_health)
	queue_free()
