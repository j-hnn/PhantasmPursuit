extends Node2D

var can_spawn = true
var spawn_delay = 5
var collected = 0
var switched = false


func _ready():
	pass

func _process(delta):
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
	enemy.global_position = Vector2(0, 0)
	get_parent().add_child(enemy)
	enemy.player_hit.connect(_on_player_hit)
	
func _on_player_hit():
	print("player hit")
	reset_player()
	
func reset_player():
	collected = 0
	switched = false
