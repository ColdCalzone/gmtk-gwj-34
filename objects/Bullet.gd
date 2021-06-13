extends KinematicBody2D

export(int) var speed : int = 600

export(int) var damage : int = 1

onready var on_screen = $VisibilityNotifier2D

var sender : Node

func _ready():
	$Timer.connect("timeout", self, "kill")

func damage(amount):
	pass

func _physics_process(delta : float) -> void:
	if !on_screen.is_on_screen():
		kill()
	var collision = move_and_collide(Vector2.UP.rotated(rotation) * speed * delta)
	if collision:
		collision.get_collider().damage(damage)
		kill()

func kill():
	queue_free()
