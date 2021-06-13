extends KinematicBody2D
class_name Enemy

export var speed : float = 300


export var health : int = 2
export var max_health : int = 2

export var damage : int = 1

var ANIMATION_SPEED = 10
var frame : float = 0.0

func damage(amount : int):
	health -= amount

func _ready():
	pass
