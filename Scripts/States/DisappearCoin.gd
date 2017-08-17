extends 'State.gd'

var pos

func enter(entity):
	entity.set_process_input(false)
	entity.set_fixed_process(false)
	get_node('SamplePlayer').play()
	entity.queue_free()