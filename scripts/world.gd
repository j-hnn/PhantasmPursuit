extends Node2D

@onready var spawn = [
	$TileMap/Spawn1,
	$TileMap/Spawn2,
	$TileMap/Spawn3,
	$TileMap/Spawn4
	]
@onready var player = $TileMap/player
@onready var lever_gui = player.lever_rect
@onready var exit = $TileMap/Exit
@onready var timer = $Timer
@onready var one_sec_timer = $TileMap/OneSecTimer
@onready var timer_bar = $TimerGUI/TimerProgress
@onready var timer_label = $TimerGUI/TimerLabel
@onready var enemy_container = $TileMap/EnemyContainer
@onready var color_shader = $ColorShader
@onready var color_shader_2 = $ColorShader2
@onready var flash_1 = $Flash/flash1
@onready var flash_2 = $Flash/flash2
@onready var diesound = $diesound
@onready var leversound = $leversound

var can_spawn = true
var num_enemies = 0
var time_left = 60
var spawn_delay = 2
var can_switch = false
var player_inside = false
var switched = false
var spawn_pos = Vector2(0, 0)
var collected = 0

func _ready():
	timer_label.text = "Time Left: " + str(time_left) + " seconds"
	timer_bar.value = time_left
	player.hit.connect(_on_enemy_hit)

func _process(_delta):
	if can_spawn and num_enemies < 10:
		can_spawn = false
		spawn_enemy()
		await get_tree().create_timer(spawn_delay).timeout
		can_spawn = true
		
	if time_left < 0:
		get_tree().change_scene_to_file("res://scenes/lose_screen.tscn")
		
	if collected >= 5:
		can_switch = true
	else:
		can_switch = false
		
	if Input.is_action_pressed("flip") and player_inside:
			print("flip switch")
			flip_lever()
			switched = true
		
	if switched:
		exit.visible = true
		
func _on_enemy_hit():
	num_enemies -= 1
	collected += 1

func spawn_enemy():
	var enemy = load("res://scenes/enemy.tscn").instantiate()
	enemy.player = player
	enemy.visible = true
	get_spawn()
	enemy.global_position = spawn_pos
	get_node("TileMap/EnemyContainer").add_child(enemy)
	enemy.player_hit.connect(_on_player_hit)
	num_enemies += 1
	
func get_spawn():
	spawn_pos = spawn[randi() % spawn.size()].global_position
	
func _on_player_hit():
	diesound.play()
	num_enemies = 0
	flash()
	reset_player()
	
func reset_player():
	collected = 0
	switched = false
	can_switch = false
	exit.visible = false
	unflip_lever()

func _on_player_collect_enough():
	can_switch = true

func _on_lever_body_entered(body):
	if body is Player and can_switch:
		lever_gui.visible = true
		player_inside = true

func _on_lever_body_exited(body):
	if body is Player:
		lever_gui.visible = false
		player_inside = false

func _on_exit_body_entered(body):
	if body is Player and switched:
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")

func flip_lever():
	$TileMap/Lever/Sprite2D.visible = false
	$TileMap/Lever/Sprite2D2.visible = true
	color_shader.visible = false
	color_shader_2.visible = true
	leversound.play()
	
func unflip_lever():
	$TileMap/Lever/Sprite2D.visible = true
	$TileMap/Lever/Sprite2D2.visible = false
	color_shader.visible = true
	color_shader_2.visible = false

func _on_one_sec_timer_timeout():
	time_left -= 1
	timer_label.text = "Time Left: " + str(time_left) + " seconds"
	timer_bar.value = time_left

func blacknwhite():
	flash_1.visible = true
	await get_tree().create_timer(.2).timeout 
	flash_2.visible = true
	flash_1.visible = false
	await get_tree().create_timer(.2).timeout 
	flash_2.visible = false

func flash():
	var random = randi_range(1, 5) * 100
	for i in range(random):
		blacknwhite()
