extends 'State.gd'

var pos

func enter(entity):
	if entity.teleport:
		var player = get_tree().get_nodes_in_group('player').front()
	#	__parent.get_node('IdlePlayer').counter.pop_front()
		if player != null:
			player.set_pos(pos)
	entity.set_process_input(false)
	entity.set_fixed_process(false)
	entity.queue_free()
	