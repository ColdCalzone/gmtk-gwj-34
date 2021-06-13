extends Node


enum WaveTypes {BASIC}

export(Array, WaveTypes) var waves

var wave_number := 0
var enemy := {
	"basic": preload("res://objects/enemies/BasicEnemy.tscn"),
	"turret": preload("res://objects/enemies/TurretEnemy.tscn")
}
var enemies := []

signal wave_complete
signal all_waves_complete



func run_wave() -> void:
	match waves[wave_number]:
		WaveTypes.BASIC:
			spawn_enemy(enemy.turret, Vector2(-200, -50))
			spawn_enemy(enemy.turret, Vector2(200, -50))



func spawn_enemy(enemy_scene: PackedScene, position_: Vector2) -> void:
	var enemy := enemy_scene.instance()
	enemy.position = position_
	
	# Connect enemy death signal to `enemy_death` later
	
	enemies.append(enemy)
	
	add_child(enemy)



func enemy_death(enemy: KinematicBody2D) -> void:
	enemies.erase(enemy)
	
	if not len(enemies):
		wave_number += 1
		emit_signal("wave_complete")
		
		if wave_number == len(waves):
			emit_signal("all_waves_complete")
		else:
			run_wave()



func _ready() -> void:
	run_wave()
