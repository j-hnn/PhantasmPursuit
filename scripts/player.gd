class_name Player extends CharacterBody2D

signal hit

@onready var muzzle = $Muzzle
@onready var collected_bar = $Camera2D/player_gui/BackgroundRect/CollectedRect/CollectedLabel/CollectedProgress
@onready var energy_bar = $Camera2D/player_gui/BackgroundRect/EnergyRect/EnergyLabel/EnergyBar
@onready var sprite = $AnimatedSprite2D
@onready var lever_rect = $Camera2D/player_gui/BackgroundRect/LeverRect

@export var speed = 300

var dir : Vector2
var fire_rate = 0.05
var regen_rate = 0.5
var can_fire = true
var can_regen = true
var energy = 100 
var collected = 0
var need_collect = 5

func _ready():
	energy_bar.value = energy
	sprite.play("default")

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	velocity = dir * speed
	move_and_slide()
	collected_bar.value = collected * (100 / need_collect)
	energy_bar.value = energy
	
	if Input.is_action_pressed("fire") and energy > 0 and can_fire:
		fire_laser()
	elif energy < 100 and can_regen:
		regen_energy()
			
func _unhandled_input(_event):
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")
	dir = dir.normalized()

func fire_laser():
	can_fire = false
	energy -= 3
	var laser = load("res://scenes/laser.tscn").instantiate()
	laser.enemy_hit.connect(_on_enemy_hit)
	laser.global_position = muzzle.global_position
	laser.rotation = self.rotation
	get_parent().add_child(laser)
	await get_tree().create_timer(fire_rate).timeout 
	can_fire = true
	
func _on_enemy_hit():
	collected += 1
	hit.emit()
	
func regen_energy():
	can_regen = false
	energy += 1
	await get_tree().create_timer(regen_rate).timeout
	can_regen = true
