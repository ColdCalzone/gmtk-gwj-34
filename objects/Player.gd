extends KinematicBody2D

export var speed : float = 400

export var health : int = 20

onready var turret = $Turret

onready var sprite = $Sprite
const ANIMATION_SPEED = 10
var frame : float = 0.0

var turret_offset = 0

func _ready() -> void:
	turret.is_player = true
	turret.set_as_toplevel(true)

func _physics_process(delta : float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right") : direction.x += 1
	if Input.is_action_pressed("ui_left") : direction.x -= 1
	if Input.is_action_pressed("ui_down") : direction.y += 1
	if Input.is_action_pressed("ui_up") : direction.y -= 1
	move_and_collide(direction.normalized() * speed * delta)
	
	if turret.global_position.distance_to(position) > 80:
		turret.global_position = (-(global_position - turret.global_position).normalized() * 120) + global_position

func _process(delta) -> void:
	var direction = Vector2(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up"))
	if direction.length_squared() > 0:
		if direction.x != 0:
			sprite.rotation = 1.57 if direction.x > 0.0 else -1.57
		if direction.y != 0:
			sprite.rotation = 3.14 if direction.y > 0.0 else 0.0
		frame += ANIMATION_SPEED * delta
		if frame > 2.0: frame = 0.0
		sprite.frame = frame + 1
	else:
		frame = 0.0
		sprite.frame = 0
