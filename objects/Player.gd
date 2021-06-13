extends KinematicBody2D

class_name Player

export var speed : float = 400

export var health : int = 20
export var max_health : int = 20

onready var turrets = get_tree().get_nodes_in_group("Turret")

onready var sprite = $Sprite
onready var iframes = $Timer
var invulnerable = false
const ANIMATION_SPEED = 10
var frame : float = 0.0

var id_tracker : int = 0

func _ready() -> void:
	for turret in turrets:
		if turret in get_tree().get_nodes_in_group("Player"):
			turret.is_player = true
			turret.bullet.speed = 700
			turret.bullet.damage = 1
			turret.turret_id = id_tracker
			turret.set_as_toplevel(true)
		else:
			turrets.erase(turret)
	Global.subscribe(self)

func _save_data() -> void:
	Global.set_data("player_pos", global_position)
	Global.set_data("player_health", health)
	Global.set_data("player_max_health", max_health)
	Global.set_data("player_speed", speed)

func damage(amount : int):
	health -= amount
	iframes.start()

func _physics_process(delta : float) -> void:
	if !iframes.is_stopped():
		sprite.modulate.a = 0.3
		set_collision_layer_bit(0, false)
		for turret in turrets:
			turret.set_collision_layer_bit(0, false)
			turret.sprite.modulate.a = 0.3
		invulnerable = true
	elif invulnerable:
		sprite.modulate.a = 1
		set_collision_layer_bit(0, true)
		for turret in turrets:
			turret.set_collision_layer_bit(0, true)
			turret.sprite.modulate.a = 1
		invulnerable = false
	
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right") : direction.x += 1
	if Input.is_action_pressed("move_left") : direction.x -= 1
	if Input.is_action_pressed("move_down") : direction.y += 1
	if Input.is_action_pressed("move_up") : direction.y -= 1
	move_and_collide(direction.normalized() * speed * delta)
	
	# poggera
	for turret in turrets:
		#turret.rotation -= delta * (Input.get_action_strength("aim_left") - Input.get_action_strength("aim_right")) * turret.rotation_speed
		#turret.rotation = clamp(turret.rotation, -0.79, 0.79)
	
		if turret.global_position.distance_to(global_position) > 100:
			turret.global_position = ((turret.global_position - global_position).normalized() * 120) + global_position
		for other_turret in turrets:
			if other_turret == turret: continue
			if other_turret.global_position.distance_to(turret.global_position) < 100:
				other_turret.global_position += (((other_turret.global_position - turret.global_position).normalized() * 120) + turret.global_position) * delta
	

func _process(delta) -> void:
	var direction = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	if direction.length_squared() > 0:
		if direction.y != 0:
			sprite.rotation = 3.14 if direction.y > 0.0 else 0.0
		if direction.x != 0:
			sprite.rotation = 1.57 if direction.x > 0.0 else -1.57
		frame += ANIMATION_SPEED * delta
		if frame > 2.0: frame = 0.0
		sprite.frame = frame + 1
	else:
		frame = 0.0
		sprite.frame = 0
