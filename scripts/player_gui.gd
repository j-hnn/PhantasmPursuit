extends CanvasLayer

@onready var progress_bar = $ProgressLabel/ProgressBar
@onready var energy_bar = $EnergyLabel/EnergyBar

var progress_bar_text = 0
var energy_bar_text = 100


func _ready():
	progress_bar.value = progress_bar_text
	energy_bar.value = energy_bar_text



func _process(delta):
	pass
