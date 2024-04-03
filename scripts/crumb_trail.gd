extends Area2D

@onready var types = [
	$Type1,
	$Type2,
	$Type3,
	$Type4
	]


func _ready():
	types.pick_random().visible = true
	
	await get_tree().create_timer(2.5).timeout
	queue_free()
