extends 'State.gd'

var pos

func enter(entity):
	for shadow in get_tree().get_nodes_in_group('shadow'):
		shadow.queue_free()
	entity.set_process_input(false)
	entity.set_fixed_process(false)
	entity.queue_free()
	