extends KinematicBody2D

export(PackedScene) var bullet_scene : PackedScene = preload("res://objects/Bullet.tscn")
var bullet : Node = bullet_scene.instance()
export(bool) var is_player = true setget set_collision

const ANIMATION_SPEED = 5
var frame : float = 0.0

export(float) var rotation_speed : float = 4

export(int) var health : int = 80
export(int) var max_health : int = 80

onready var tween = $Tween
onready var sprite = $Sprite
onready var timer = $Timer
# Mounted to the Sprite because rotation go brrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr
onready var audio = $Sprite/AudioStreamPlayer2D
var player_sound : AudioStream = preload("res://assets/sfx/raw/player_shot.wav")
var slow_enemy_sound : AudioStream = preload("res://assets/sfx/raw/slower_fire_enemy.wav")
onready var parent = get_parent()

var turret_id : int

func _ready():
	Global.subscribe(self)
	if is_player:
		audio.set_stream(player_sound)
	else:
		audio.set_stream(slow_enemy_sound)

func _save_data() -> void:
	Global.set_data("turret_%s_pos"%turret_id, global_position)
	Global.set_data("turret_%s_rotation"%turret_id, rotation)
	Global.set_data("turret_%s_health"%turret_id, health)
	Global.set_data("turret_%s_max_health"%turret_id, max_health)
	Global.set_data("turret_%s_bullet_speed"%turret_id, bullet.speed)
	Global.set_data("turret_%s_bullet_damage"%turret_id, bullet.damage)

func set_collision(value : bool):
	is_player = value
	if !is_player:
		# Tell the bullet to hit players and turrets
		bullet.set_collision_mask_bit(0, true)
	else:
		# Or to hit enemies
		bullet.set_collision_mask_bit(1, true)


func damage(amount : int):
	health -= amount

func _physics_process(delta):
	var closest_enemy_pos : Vector2 = Vector2.ZERO
	for enemy in (get_tree().get_nodes_in_group("Enemy") if is_player else get_tree().get_nodes_in_group("Player")):
		if global_position.distance_to(enemy.global_position) < global_position.distance_to(closest_enemy_pos) or closest_enemy_pos == Vector2.ZERO:
			closest_enemy_pos = enemy.global_position
	
	var angle = global_position.angle_to_point(closest_enemy_pos) - 1.57
	rotation = lerp_angle(rotation, angle, 0.15)# * delta
	if is_player:
		rotation += (Input.get_action_strength("aim_right") - Input.get_action_strength("aim_left")) * rotation_speed * delta
	angle = wrapf(angle, 0, 6.28)
	rotation = wrapf(rotation, 0, 6.28)
	
	if is_player:
		if Input.is_action_pressed("shooty"):
			if timer.is_stopped():
				timer.start()
				shoot()
		else:
			timer.stop()

func _process(delta : float) :
	frame += delta * (ANIMATION_SPEED)
	if frame > 5.0: frame = 0.0
	sprite.frame = int(frame)

func shoot():
	bullet.rotation = rotation
	bullet.position = global_position
	get_tree().get_root().add_child(bullet.duplicate())
	audio.play()
