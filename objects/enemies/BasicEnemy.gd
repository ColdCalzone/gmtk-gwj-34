extends KinematicBody2D

onready var health_pack = preload("res://objects/HealthPack.tscn").instance()

export var speed : float = 375

export var health : int = 2
export var max_health : int = 200

export var damage : int = 1

onready var sprite = $Sprite
const ANIMATION_SPEED = 10
var frame : float = 0.0

enum STATE {SEARCHING_LEFT, SEARCHING_RIGHT, LOCKING, LOCKED}

var state = STATE.SEARCHING_LEFT

var target : Node2D = null

var targeting_time : float = 0.0

func _ready():
	pass

func damage(amount : int):
	health -= amount

func _physics_process(delta : float) -> void:
	print("Enemy: ", health)
	if target == null:
		target = get_target()
	else:
		var movement = calculate_movement(position.x, position.y, delta)
		var collision = move_and_collide(movement)
		if collision:
			collision.get_collider().damage(damage)
	if health <= 0:
		health_pack.global_position = global_position
		get_parent().add_child(health_pack)
		queue_free()

func _process(delta):
	match state:
		STATE.SEARCHING_LEFT:
			if frame >= 4:
				state = STATE.SEARCHING_RIGHT
			frame += delta * ANIMATION_SPEED
		STATE.SEARCHING_RIGHT:
			if frame <= 0:
				state = STATE.SEARCHING_LEFT
			frame -= delta * ANIMATION_SPEED
		STATE.LOCKING:
			frame = max(frame, 4.0)
			frame += (delta/2) * ANIMATION_SPEED
			if frame >= 8:
				state = STATE.LOCKED
		STATE.LOCKED:
			frame = 8
	sprite.frame = int(frame)

func get_target():
	var player = get_tree().get_nodes_in_group("Player")[0]
	var angle = position.angle_to_point(player.position) - 1.57
	rotation = lerp_angle(rotation, angle, 0.01)# * delta
	angle = wrapf(angle, 0, 6.28)
	rotation = wrapf(rotation, 0, 6.28)
	if abs(angle - rotation) < 0.2:
		state = STATE.LOCKING
		return player
	return null

func calculate_movement(x : float, y : float, delta : float) -> Vector2:
	targeting_time += delta
	var angle = position.angle_to_point(target.position) - 1.57
	rotation = lerp_angle(rotation, angle, 0.03)
	if targeting_time > 1:
		state = STATE.LOCKED
		return Vector2.UP.rotated(rotation) * speed * delta
	else:
		return Vector2.UP.rotated(rotation) * -speed / 3 * delta
	return Vector2.ZERO
