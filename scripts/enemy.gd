class_name Phantom extends CharacterBody2D

const speed = 200
@export var player: Node2D

signal player_hit

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var trail_marker = $Trailmarker

func _ready() -> void:
	makepath()
	
func _physics_process(_delta: float) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * speed
	move_and_slide()

func makepath() -> void:
	nav_agent.target_position = player.global_position
	
func create_crumb_trail():
	var crumb = load("res://scenes/crumb_trail.tscn").instantiate()
	crumb.global_position = Vector2(self.global_position.x, self.global_position.y)
	get_parent().add_child(crumb)

func _on_timer_timeout():
	makepath()
	create_crumb_trail()


func _on_hitbox_body_entered(body):
	if body == player:
		queue_free()
		player.collected = 0
		player_hit.emit()
