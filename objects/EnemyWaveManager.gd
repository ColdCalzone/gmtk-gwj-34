extends Node


var current_level : String = "Level"

var WaveTypes : Dictionary

var waves : Array

var wave_number := 0
var enemy := {
	"basic": preload("res://objects/enemies/BasicEnemy.tscn"),
	"turret": preload("res://objects/enemies/TurretEnemy.tscn")
}
var enemies := []

var id_track : int = 0

signal wave_complete
signal all_waves_complete

func run_wave() -> void:
	for wave_enemy in WaveTypes[waves[wave_number]]:
		spawn_enemy(enemy[wave_enemy[1]], Vector2(wave_enemy[0].x, wave_enemy[0].y))
	



func spawn_enemy(enemy_scene: PackedScene, position_: Vector2) -> void:
	position_ += Vector2(randi() % 20, randi() % 10)
	var enemy := enemy_scene.instance()
	enemy.position = position_
	
	enemy.enemy_id = id_track
	id_track += 1
	
	# Connect enemy death signal to `enemy_death` later
	
	enemies.append(enemy)
	
	enemy.connect("enemy_death", self, "enemy_death")
	
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
	Global.subscribe(self)
	var file = File.new()
	var tracker : int = 0
	if !file.open("res://waves.tres", File.READ):
		var content = JSON.parse(file.get_as_text()).result
		WaveTypes = content
	if !file.open("res://wavesets/%s.tres" % current_level, File.READ):
		var content = JSON.parse(file.get_as_text()).result
		waves = content

func _save_data() -> void:
	Global.set_data("wave_manager_wave", wave_number)
	Global.set_data("wave_manager_waves", waves)
	Global.set_data("wave_manager_enemy_ids", id_track)
	Global.set_data("wave_manager_enemies", enemies)
