extends CanvasLayer

func _ready():
	$AudioStreamPlayer2D.play()

func _on_replay_btn_pressed():
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
