class_name Player extends CharacterBody2D

@onready var muzzle = $Muzzle

@export var speed = 300

var dir : Vector2
var fire_rate = 0.05
var can_fire = true
var energy = 100 



func _physics_process(_delta):
	look_at(get_global_mouse_position())
	velocity = dir * speed
	move_and_slide()
	print(energy)
	
	if Input.is_action_pressed("fire") and energy > 0 and can_fire:
		fire_laser()
	elif energy < 100:
		energy += 1
			
func _unhandled_input(_event):
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")
	dir = dir.normalized()

func fire_laser():
	can_fire = false
	energy -= 1
	var laser = load("res://scenes/laser.tscn").instantiate()
	laser.global_position = muzzle.global_position
	laser.rotation = self.rotation
	get_parent().add_child(laser)
	await get_tree().create_timer(fire_rate).timeout 
	can_fire = true
	laser.enemy_hit.connect(_on_enemy_hit)
	
func _on_enemy_hit():
	pass
	#code when enemy hit
	#collected += 1
