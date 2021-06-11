extends KinematicBody2D

export(PackedScene) var bullet = preload("res://objects/Bullet.tscn").instance()
export(bool) var is_player = true setget set_collision

onready var tween = $Tween

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
	$Timer.connect("timeout", self, "shoot")

#func _physics_process(delta):
	#position = lerp(position, target, 0.7)

func shoot():
	bullet.rotation = rotation
	bullet.position = global_position
	get_tree().get_root().add_child(bullet.duplicate())
