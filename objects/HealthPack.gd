extends Sprite

onready var area = $Area2D

func _ready():
	area.connect("body_entered", self, "heal")

func heal(body):
	if not body is Player: return
	body.health += randi() % 5 + 3
	for turret in body.turrets:
		turret.health +=  randi() % 10 + 10
	queue_free()
