extends KinematicBody2D

export var speed : float = 400

export var health : int = 20

onready var turret = $Turret

func _ready() -> void:
	turret.is_player = true
	#turret.set_as_toplevel(true)

func _physics_process(delta : float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("ui_right") : direction.x += 1
	if Input.is_action_pressed("ui_left") : direction.x -= 1
	if Input.is_action_pressed("ui_down") : direction.y += 1
	if Input.is_action_pressed("ui_up") : direction.y -= 1
	
	move_and_collide(direction.normalized() * speed * delta)
	
	turret.position = -((position - turret.position).normalized() * 120)
