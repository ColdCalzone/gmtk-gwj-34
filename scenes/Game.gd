extends Node2D

onready var player_health = $Ui/Control/PlayerHealth
onready var turrets_health = $Ui/Control/TurretsHealth
onready var player = $Player
onready var color = $Ui/ColorRect
onready var tween = $Tween

onready var enemy_manage = $EnemyWaveManager

onready var turrets = get_tree().get_nodes_in_group("Turret")

func _ready():
	
	set_physics_process(false)
	$CPUParticles2D.emitting = true
	tween.interpolate_property(color, "modulate:a", 1.0, 0.0, 0.1)
	tween.start()
	yield(tween, "tween_all_completed")
	set_physics_process(true)
	player_health.max_value = player.max_health
	player_health.value = player.health
	turrets = player.turrets
	for turret in turrets:
		if turret in get_tree().get_nodes_in_group("Enemy"):
			turrets.erase(turret)
		else:
			turrets_health.max_value += turret.max_health
			turrets_health.value += turret.health
	enemy_manage.run_wave()

func _physics_process(delta):
	player_health.value = player.health
	turrets_health.value = 0
	for turret in turrets:
		turrets_health.value += turret.health
	if player_health.value <= 0 or turrets_health.value <= 0:
		# GAME OVER
		tween.interpolate_property(color, "modulate:a", 1.0, 0.0, 0.2)
		tween.start()
		set_physics_process(false)
		yield(tween, "tween_all_completed")
		get_tree().change_scene("res://ui/MainMenu.tscn")
	if Input.is_action_just_pressed("pause"):
		PauseMenu.open_menu()
