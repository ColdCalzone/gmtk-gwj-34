extends KinematicBody2D

export(int) var speed : int = 600

export(int) var damage : int = 1

var sender : Node

func _ready():
	$Timer.connect("timeout", self, "kill")

func damage(amount):
	pass

func _physics_process(delta : float) -> void:
	
	var collision = move_and_collide(Vector2.UP.rotated(rotation) * speed * delta)
	if collision:
		collision.get_collider().health -= damage

func kill():
	queue_free()
