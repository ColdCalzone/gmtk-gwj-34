extends Node2D

onready var buttons = [
		[$UI/ScrollContainer/EnemySelect/Basic, preload("res://objects/enemies/BasicEnemy.tscn")], 
		[$UI/ScrollContainer/EnemySelect/Turret, preload("res://objects/enemies/TurretEnemy.tscn")]
	]

onready var select_box = $UI/ScrollContainer

onready var wave_name = $UI/WaveName
onready var level_name = $UI/LevelName
onready var save_wave = $UI/SaveWave
onready var save_level = $UI/SaveLevel

onready var waveset_ui : Dictionary = {
	"Container" : $UI/CenterContainer,
	"Backdrop" : $UI/CenterContainer/Backdrop,
	"Box" : $UI/CenterContainer/Box,
	"Vbox" : $UI/CenterContainer/VBoxContainer,
	"Label" : $UI/CenterContainer/VBoxContainer/Label,
	"WaveList" : $UI/CenterContainer/VBoxContainer/WaveSet,
	"SaveButton" : $UI/CenterContainer/VBoxContainer/Submit,
	"Cancel" : $UI/CancelButton,
}

onready var current_enemy : KinematicBody2D = null

var following : bool = true

func _ready():
	print("READY")
	for button in buttons:
		button[0].connect("pressed", self, "change_enemy_type", [button[1]])
	
	save_wave.connect("pressed", self, "save_wave")
	
	save_level.connect("pressed", self, "show_waveset_ui")
	
	waveset_ui["SaveButton"].connect("pressed", self, "hide_waveset_ui")
	waveset_ui["SaveButton"].connect("pressed", self, "save_waveset")
	
	waveset_ui["Cancel"].connect("pressed", self, "hide_waveset_ui")
	
	current_enemy = buttons[0][1].instance()
	current_enemy.scale = Vector2(0.5, 0.5)
	current_enemy.remove_from_group("Enemy")
	add_child(current_enemy)

func _physics_process(delta):
	following = not (get_viewport().get_mouse_position().y > select_box.rect_position.y - select_box.margin_top) and not waveset_ui["Container"].visible
	if current_enemy != null and following:
		current_enemy.position = get_viewport().get_mouse_position() - Vector2(512, 288)

func _input(event):
	if !following: return
	if event.is_action_pressed("place_enemy"):
		add_child(current_enemy.duplicate())
	# I could give enemies an area 2d so I can use the click function
	#... or I could write a function to see if the click is within the bounds of any enemy's collision shape
	elif event.is_action_pressed("remove_enemy", true):
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			var relative_click_position = get_viewport().get_mouse_position() - Vector2(512, 288) - enemy.position
			var enemy_collision_shape 
			for child in enemy.get_children():
				if child is CollisionShape2D:
					enemy_collision_shape = child.get_shape()
			if enemy_collision_shape == null:
				return
			# vomitting and and puking and dying and 
			if relative_click_position.x > -enemy_collision_shape.extents.x/2 \
			and relative_click_position.x < enemy_collision_shape.extents.x/2 \
			and relative_click_position.y > -enemy_collision_shape.extents.y/2 \
			and relative_click_position.y < enemy_collision_shape.extents.y/2:
				remove_child(enemy)

func change_enemy_type(enemy_type):
	var old_pos = current_enemy.position
	remove_child(current_enemy)
	current_enemy = enemy_type.instance()
	add_child(current_enemy)
	current_enemy.scale = Vector2(0.5, 0.5)
	current_enemy.position = old_pos
	current_enemy.remove_from_group("Enemy")

func get_type(thing):
	if thing is BasicEnemy: return "basic"
	elif thing is TurretEnemy: return "turret"

func save_wave():
	var file = File.new()
	var content
	if !file.file_exists("res://waves.tres"):
		file.open("res://waves.tres", File.WRITE)
		file.store_string("{}")
		file.close()
	else:
		file.open("res://waves.tres", File.READ)
		content = JSON.parse(file.get_as_text()).result
		file.close()
	if !file.open("res://waves.tres", File.WRITE):
		var enemy_types_positions : Array
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			if not enemy in get_tree().get_nodes_in_group("Turret"):
				enemy_types_positions.append([{"x" : enemy.position.x * 2, "y" : enemy.position.y * 2}, get_type(enemy)])
			
		content[wave_name.text] = enemy_types_positions
		file.store_string(JSON.print(content))
		file.close()

func show_waveset_ui():
	waveset_ui["Container"].visible = true
	waveset_ui["Cancel"].visible = true
	for item in [waveset_ui["WaveList"], waveset_ui["SaveButton"], waveset_ui["Cancel"]]:
		item.mouse_filter = Control.MOUSE_FILTER_STOP
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.sprite.visble = false
	

func hide_waveset_ui():
	waveset_ui["Container"].visible = false
	waveset_ui["Cancel"].visible = false
	for item in [waveset_ui["WaveList"], waveset_ui["SaveButton"], waveset_ui["Cancel"]]:
		item.mouse_filter = Control.MOUSE_FILTER_PASS
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.sprite.visble = true

func save_waveset():
	var file = File.new()
	if !file.open("res://wavesets/%s.tres" % level_name.text, File.WRITE):
		var waves : Array = waveset_ui["WaveList"].text.split(",", false)
		var i : int = 0
		for x in waves:
			if x.find(" ") != -1:
				waves.remove(i)
			i += 1
		i = 0
		for x in waveset_ui["WaveList"].text.split(" ", false):
			if waves.size() > i:
				if x != waves[i]:
					var j : int = 0
					while x.find(" ") != -1:
						x.erase(x.find(" "), 1)
				if waves[i].find(" ") != -1:
					waves.remove(i)
			if x.find(",") == -1:
				waves.append(x)
				i += 1
		file.store_string(JSON.print(waves))
		file.close()
	waveset_ui["WaveList"].text = ""
