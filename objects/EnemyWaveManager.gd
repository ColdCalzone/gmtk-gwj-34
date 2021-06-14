extends Node


enum WaveTypes {BASIC, TWO_SHOOTER, HORDE_CHARGERS, SNIPER_CHARGERS, RANDOM}

export(Array, WaveTypes) var waves

var wave_number := 0
var enemy := {
	"basic": preload("res://objects/enemies/BasicEnemy.tscn"),
	"turret": preload("res://objects/enemies/TurretEnemy.tscn")
}
var enemies := []

var id_track : int = 0

signal wave_complete
signal all_waves_complete

# HOW TO GET MORE CONTENT: RNG BABEY!!!!

func run_wave() -> void:
	match waves[wave_number]:
		WaveTypes.BASIC:
			spawn_enemy(enemy.basic, Vector2(200, -50))
			spawn_enemy(enemy.basic, Vector2(-200, -50))
		WaveTypes.TWO_SHOOTER:
			spawn_enemy(enemy.turret, Vector2(-200, 0))
			spawn_enemy(enemy.turret, Vector2(200, 0))
		WaveTypes.HORDE_CHARGERS:
			spawn_enemy(enemy.basic, Vector2(280, 280))
			spawn_enemy(enemy.basic, Vector2(0, 280))
			spawn_enemy(enemy.basic, Vector2(-280, 280))
			spawn_enemy(enemy.basic, Vector2(280, -280))
			spawn_enemy(enemy.basic, Vector2(0, -280))
			spawn_enemy(enemy.basic, Vector2(-280, -280))
			spawn_enemy(enemy.basic, Vector2(-280, 0))
			spawn_enemy(enemy.basic, Vector2(280, 0))
		WaveTypes.SNIPER_CHARGERS:
			spawn_enemy(enemy.turret, Vector2(0, -280))
			spawn_enemy(enemy.basic, Vector2(280, 280))
			spawn_enemy(enemy.basic, Vector2(0, 280))
			spawn_enemy(enemy.basic, Vector2(-280, 280))
		WaveTypes.RANDOM:
			wave_number -= 1
			for x in randi() % 10:
				spawn_enemy(enemy.basic if randi() % 6 > 1 else enemy.turret, Vector2(range(-280, 280)[randi() % 400], range(-280, 280)[randi() % 400]))



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

func _save_data() -> void:
	Global.set_data("wave_manager_wave", wave_number)
	Global.set_data("wave_manager_waves", waves)
	Global.set_data("wave_manager_enemy_ids", id_track)
	Global.set_data("wave_manager_enemies", enemies)
