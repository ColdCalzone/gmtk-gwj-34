extends KinematicBody2D

export(PackedScene) var bullet = preload("res://objects/Bullet.tscn").instance()
export(bool) var is_player = true setget set_collision

const ANIMATION_SPEED = 5
var frame : float = 0.0

export(float) var rotation_speed : float = 4

export(int) var health : int = 80

onready var tween = $Tween
onready var sprite = $Sprite
onready var timer = $Timer
onready var parent = get_parent()

func set_collision(value : bool):
	is_player = value
	if !is_player:
		# Tell the bullet to hit players and turrets
		bullet.set_collision_mask_bit(0, true)
	else:
		# Or to hit enemies
		bullet.set_collision_mask_bit(1, true)

#func _ready():
	#timer.connect("timeout", self, "shoot")

func damage(amount : int):
	health -= amount

func _physics_process(delta):
	if Input.is_action_pressed("shooty"):
		shoot()

func _process(delta : float) :
	frame += delta * (ANIMATION_SPEED/timer.wait_time)
	if frame > 5.0: frame = 0.0
	sprite.frame = int(frame)

func shoot():
	bullet.rotation = rotation
	bullet.position = global_position
	get_tree().get_root().add_child(bullet.duplicate())
