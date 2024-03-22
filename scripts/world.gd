extends Node2D

@onready var spawn = [
	$TileMap/Spawn1,
	$TileMap/Spawn2,
	$TileMap/Spawn3,
	$TileMap/Spawn4
	]
@onready var player = $TileMap/player
@onready var lever_gui = $LeverGUI
@onready var exit = $TileMap/Exit
@onready var timer = $Timer
@onready var one_sec_timer = $TileMap/OneSecTimer
@onready var timer_bar = $TimerGUI/TimerProgress
@onready var timer_label = $TimerGUI/TimerLabel

var can_spawn = true
var time_left = 180
var spawn_delay = 2
var can_switch = false
var player_inside = false
var switched = false
var spawn_pos = Vector2(0, 0)

func _ready():
	timer_label.text = "Time Left: " + str(time_left) + " seconds"
	timer_bar.value = time_left
	player.collect_enough.connect(_on_player_collect_enough)

func _process(_delta):
	
	if can_spawn:
		can_spawn = false
		spawn_enemy()
		await get_tree().create_timer(spawn_delay).timeout
		can_spawn = true
		
	if Input.is_action_pressed("flip") and player_inside:
			print("flip switch")
			switched = true
		
	if switched:
		exit.visible = true
		
	if Input.is_action_pressed("spawn"):
		spawn_enemy()

func spawn_enemy():
	var enemy = load("res://scenes/enemy.tscn").instantiate()
	enemy.player = player
	get_spawn()
	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
	enemy.player_hit.connect(_on_player_hit)
	
func get_spawn():
	spawn_pos = spawn[randi() % spawn.size()].global_position
	
func _on_player_hit():
	reset_player()
	
func reset_player():
	switched = false
	can_switch = false
	exit.visible = false

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
		get_tree().quit()
		print("win")
		#replace with code to win screen


func _on_timer_timeout():
	print("lose")
	get_tree().quit()

func _on_one_sec_timer_timeout():
	time_left -= 1
	timer_label.text = "Time Left: " + str(time_left) + " seconds"
	timer_bar.value = time_left
