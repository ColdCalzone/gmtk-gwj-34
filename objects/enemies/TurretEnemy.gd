extends Enemy

onready var health_pack = preload("res://objects/HealthPack.tscn").instance()


onready var sprite = $Sprite
onready var turret = $Turret
onready var timer = $Timer

onready var player : Node

enum STATE {SEARCHING, LOCKED}

var state = STATE.SEARCHING

var target : Node = null

func ready():
	speed = 100
	health = 3
	max_health = 3
	#damage = 1
	turret.bullet.damage = 1
	turret.health = 10
	turret.max_health = 10
	turret.bullet.speed = 400
	turret.is_player = false
	turret.set_as_toplevel(true)
	for thing in get_tree().get_nodes_in_group("Player"):
		if not thing in get_tree().get_nodes_in_group("Turret"):
			player = thing

func _physics_process(delta : float) -> void:
	match state:
		STATE.SEARCHING: 
			if !target:
				target = get_target()
			else:
				state = STATE.LOCKED
		STATE.LOCKED:
			var collision = move_and_collide(calculate_movement(delta))
			if collision:
				collision.get_collider().damage(damage)
			if timer.is_stopped():
				timer.start()
				turret.shoot()
	if health <= 0 or turret.health <= 0:
		health_pack.global_position = global_position
		get_parent().add_child(health_pack)
		queue_free() 
	var collision = move_and_collide(Vector2.ZERO)

func get_target():
	if !player:
		for thing in get_tree().get_nodes_in_group("Player"):
			if not thing in get_tree().get_nodes_in_group("Turret"):
				player = thing
		return null
	var angle = position.angle_to_point(player.position) #- 1.57
	sprite.rotation = lerp_angle(sprite.rotation, global_position.angle_to_point(player.global_position), 0.2)
	angle = wrapf(angle, 0, 6.28)
	sprite.rotation = wrapf(sprite.rotation, 0, 6.28)
	if abs(angle - sprite.rotation) < 0.2:
		state = STATE.LOCKED
		return player
	return null

func calculate_movement(delta : float) -> Vector2:
	var movement : Vector2
	var angle = position.angle_to_point(target.position) - 1.57
	sprite.rotation = lerp_angle(sprite.rotation, angle, 0.03)
	if player.global_position.distance_to(global_position) < 500:
		movement += ((((player.global_position - global_position).normalized() * speed) + global_position) * delta).rotated(-angle)
	if player.global_position.distance_to(global_position) > 520:# and player.global_position.distance_to(global_position) > 500:
		movement += ((((player.global_position + global_position).normalized() * speed/2) + global_position) * delta).rotated(angle)
#	for enemy in get_tree().get_nodes_in_group("Enemy"):
#		if enemy.global_position.distance_to(position) < 100:
#			movement += ((((enemy.global_position - global_position).normalized() * 120) + global_position) * delta).rotated(-angle)
	print(movement)
	return movement
