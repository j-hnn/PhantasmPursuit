extends Node2D

var can_spawn = true
var spawn_delay = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
