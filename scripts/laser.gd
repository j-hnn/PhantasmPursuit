extends CharacterBody2D

signal enemy_hit

var speed = 500

func _ready():
	await get_tree().create_timer(5).timeout
	queue_free()
	
func _physics_process(_delta):
	velocity = transform.x * speed
	move_and_slide()
	
func _on_hithox_body_entered(body):
	if not body is Player:
		queue_free()
		if body is Phantom:
			body.queue_free()
			enemy_hit.emit()
