extends Area2D

func _ready():
	await get_tree().create_timer(2.5).timeout
	queue_free()
