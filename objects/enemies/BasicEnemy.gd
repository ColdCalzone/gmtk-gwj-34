extends Enemy

onready var health_pack = preload("res://objects/HealthPack.tscn").instance()

onready var sprite = $Sprite

enum STATE {SEARCHING_LEFT, SEARCHING_RIGHT, LOCKING, LOCKED}

var state = STATE.SEARCHING_LEFT

var target : Node2D = null

var targeting_time : float = 0.0

func _ready():
	pass

func _physics_process(delta : float) -> void:
	if target == null:
		target = get_target()
	else:
		var movement = calculate_movement(delta)
		var collision = move_and_collide(movement)
		if collision:
			if collision.get_collider().get_collision_mask_bit(0) == true:
				collision.get_collider().damage(damage)
	if health <= 0:
		var player_health = get_parent().get_parent().player_health
		var turret_health = get_parent().get_parent().turrets_health
		var value = int(((player_health.max_value + turret_health.max_value) / (turret_health.value + player_health.value)) * 5)
		if (randi() % value) >= 5 and value > 1:
			health_pack.global_position = global_position
			get_parent().add_child(health_pack)
		queue_free() 
		inform_of_death()

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
	if abs(angle - rotation) < 0.4:
		state = STATE.LOCKING
		return player
	return null

func calculate_movement(delta : float) -> Vector2:
	targeting_time += delta
	var angle = position.angle_to_point(target.position) - 1.57
	rotation = lerp_angle(rotation, angle, 0.03)
	if targeting_time > 1:
		return Vector2.UP.rotated(rotation) * speed * delta
	else:
		return Vector2.UP.rotated(rotation) * -speed / 3 * delta
	return Vector2.ZERO
