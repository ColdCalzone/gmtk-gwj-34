extends Enemy

class_name TurretEnemy

onready var health_pack = preload("res://objects/HealthPack.tscn").instance()


onready var sprite = $Sprite
onready var turret = $Turret
onready var timer = $Timer

onready var player : Node

enum STATE {SEARCHING_LEFT, SEARCHING_RIGHT, LOCKED}

var state = STATE.SEARCHING_LEFT

var target : Node = null

func ready():
	speed = 100
	health = 5
	max_health = 5
	#damage = 1
	turret.bullet.damage = 2
	turret.health = 20
	turret.max_health = 20
	turret.bullet.speed = 400
	yield(get_tree().create_timer(randf() + 1.0), "timeout")
	turret.is_player = false
	turret.set_as_toplevel(true)
	for thing in get_tree().get_nodes_in_group("Player"):
		if not thing in get_tree().get_nodes_in_group("Turret"):
			player = thing

func _process(delta):
	match state:
		STATE.SEARCHING_LEFT:
			frame += delta * ANIMATION_SPEED
			if frame >= 2:
				state = STATE.SEARCHING_RIGHT
		STATE.SEARCHING_RIGHT:
			frame -= delta * ANIMATION_SPEED
			if frame <= 0:
				state = STATE.SEARCHING_LEFT
		STATE.LOCKED:
			frame = 3
	sprite.frame = int(frame)

func _physics_process(delta : float) -> void:
	match state:
		STATE.SEARCHING_LEFT, STATE.SEARCHING_RIGHT:
			if !target:
				target = get_target()
			else:
				state = STATE.LOCKED
		STATE.LOCKED:
			var collision = move_and_collide(calculate_movement(delta))
			if collision:
				if collision.get_collider().get_collision_layer_bit(0) == true:
					collision.get_collider().damage(damage)
			if timer.is_stopped():
				timer.start()
				turret.shoot()
	if health <= 0 or turret.health <= 0:
		var player_health = get_parent().get_parent().player_health
		var turret_health = get_parent().get_parent().turrets_health
		var value = int(((player_health.max_value + turret_health.max_value) / (turret_health.value + player_health.value)) * 5)
		if (randi() % value) >= 3 and value > 1:
			health_pack.global_position = global_position
			get_parent().add_child(health_pack)
		queue_free() 
		inform_of_death()
	turret.position = ((turret.position - position).normalized() * 120)

func get_target():
	if !player:
		for thing in get_tree().get_nodes_in_group("Player"):
			if not thing in get_tree().get_nodes_in_group("Turret"):
				player = thing
		return null
	var angle = position.angle_to_point(player.position) #- 1.57
	sprite.rotation = lerp_angle(sprite.rotation, global_position.angle_to_point(player.global_position), 0.05)
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
	return movement
