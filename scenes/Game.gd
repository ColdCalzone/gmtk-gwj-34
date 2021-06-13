extends Node2D

onready var player_health = $Control/PlayerHealth
onready var turrets_health = $Control/TurretsHealth
onready var player = $Player
onready var turrets = get_tree().get_nodes_in_group("Turret")

func _ready():
	$CPUParticles2D.emitting = true
	player_health.max_value = player.max_health
	player_health.value = player.health
	turrets = player.turrets
	for turret in turrets:
		if turret in get_tree().get_nodes_in_group("Enemy"):
			turrets.erase(turret)
		else:
			turrets_health.max_value += turret.max_health
			turrets_health.value += turret.health

func _physics_process(delta):
	player_health.value = player.health
	turrets_health.value = 0
	for turret in turrets:
		turrets_health.value += turret.health
	if Input.is_action_just_pressed("pause"):
		PauseMenu.open_menu()
