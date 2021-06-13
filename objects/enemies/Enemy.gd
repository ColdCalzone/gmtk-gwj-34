extends KinematicBody2D
class_name Enemy

export var speed : float = 300

var enemy_id : int

export var health : int = 2
export var max_health : int = 2

export var damage : int = 1

var ANIMATION_SPEED = 10
var frame : float = 0.0

func damage(amount : int):
	health -= amount

signal enemy_death(enemy)

func inform_of_death():
	emit_signal("enemy_death", self)

func _ready():
	Global.subscribe(self)

func _save_data() -> void:
	Global.set_data("enemy_%s_pos"%enemy_id, global_position)
	Global.set_data("enemy_%s_health"%enemy_id, health)
	Global.set_data("enemy_%s_max_health"%enemy_id, max_health)
	Global.set_data("enemy_%s_speed"%enemy_id, speed)
	Global.set_data("enemy_%s_rotation"%enemy_id, rotation)
	Global.set_data("enemy_%s_damage"%enemy_id, damage)
