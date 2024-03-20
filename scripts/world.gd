extends Node2D

@onready var spawn = [
	$TileMap/Spawn1,
	$TileMap/Spawn2,
	$TileMap/Spawn3,
	$TileMap/Spawn4
	]

var can_spawn = true
var spawn_delay = 2
var collected = 0
var switched = false
var spawn_pos = Vector2(0, 0)

func _process(_delta):
	if can_spawn:
		can_spawn = false
		spawn_enemy()
		await get_tree().create_timer(spawn_delay).timeout
		can_spawn = true
		
	if Input.is_action_pressed("spawn"):
		spawn_enemy()

func spawn_enemy():
	var enemy = load("res://scenes/enemy.tscn").instantiate()
	enemy.player = $TileMap/player
	get_spawn()
	enemy.global_position = spawn_pos
	get_parent().add_child(enemy)
	enemy.player_hit.connect(_on_player_hit)
	
func get_spawn():
	spawn_pos = spawn[randi() % spawn.size()].global_position
	
func _on_player_hit():
	reset_player()
	
func reset_player():
	collected = 0
	switched = false
