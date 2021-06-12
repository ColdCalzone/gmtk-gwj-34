extends KinematicBody2D

export(PackedScene) var bullet = preload("res://objects/Bullet.tscn").instance()
export(bool) var is_player = true setget set_collision

const ANIMATION_SPEED = 5
var frame : float = 0.0

onready var tween = $Tween
onready var sprite = $Sprite
onready var timer = $Timer
onready var parent = get_parent()

func set_collision(value : bool):
	is_player = value
	if !is_player:
		# Tell the bullet to hit players and turrets
		bullet.collision_mask = 1
	else:
		# Or to hit enemies
		bullet.collision_mask = 2

func _ready():
	bullet.damage = 10
	bullet.speed = 700
	rotation_degrees = 90
	timer.connect("timeout", self, "shoot")

#func _physics_process(delta):
	#print(global_position.distance_to(parent.global_position))
	#if global_position.distance_to(parent.global_position) > 160.0:
		#global_position = ((global_position - parent.position).normalized() * 120)
	#else:
		#global_position = -((global_position - parent.position).normalized() * 120)

func _process(delta : float) :
	frame += delta * (ANIMATION_SPEED/timer.wait_time)
	if frame > 5.0: frame = 0.0
	sprite.frame = int(frame)

func shoot():
	bullet.rotation = rotation
	bullet.position = global_position
	get_tree().get_root().add_child(bullet.duplicate())
