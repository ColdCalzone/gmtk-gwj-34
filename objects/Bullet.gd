extends KinematicBody2D

export(int) var speed : int = 600

export(int) var damage : int = 1

var sender : Node

func _ready():
	$Timer.connect("timeout", self, "kill")

func _physics_process(delta : float) -> void:
	move_and_collide(Vector2.UP.rotated(rotation) * speed * delta)

func kill():
	queue_free()
