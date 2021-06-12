extends KinematicBody2D

export var speed : float = 350

export var health : int = 1

export var damage : int = 1

onready var sprite = $Sprite
#const ANIMATION_SPEED = 10
#var frame : float = 0.0

var target : Node2D = null

var targeting_time : float = 0.0

func _ready():
	pass

func _physics_process(delta : float) -> void:
	if target == null:
		target = get_target()
	else:
		var movement = calculate_movement(position.x, position.y, delta)
		var collision = move_and_collide(movement)
		if collision:
			collision.get_collider().damage(damage)
	if health <= 0:
		queue_free()

func get_target():
	var player = get_tree().get_nodes_in_group("Player")[0]
	var angle = position.angle_to_point(player.position) - 1.57
	rotation = lerp_angle(rotation, angle, 0.01)# * delta
	if abs(angle - rotation) < 0.2:
		return player
	return null

func calculate_movement(x : float, y : float, delta : float) -> Vector2:
	targeting_time += delta
	var angle = position.angle_to_point(target.position) - 1.57
	rotation = lerp_angle(rotation, angle, 0.03)
	if targeting_time > 1:
		return Vector2.UP.rotated(rotation) * speed * delta
	else:
		return Vector2.UP.rotated(rotation) * -speed / 3 * delta
	return Vector2.ZERO
