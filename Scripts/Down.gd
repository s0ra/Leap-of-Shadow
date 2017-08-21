extends TextureProgress

var percent = 0

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta_time):
	set_value(percent)