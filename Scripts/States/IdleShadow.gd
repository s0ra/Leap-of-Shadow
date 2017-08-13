extends 'State.gd'

onready var __game = get_node('/root/Game')
onready var __board = get_node('/root/Game/Board')
onready var __pathfinding = get_node('/root/Game/Pathfinding')

func enter(entity):
	entity.set_process_input(true)
	entity.set_fixed_process(false)
	if not entity.path.empty():
		var state = self.__parent.get_node('Moving')
		entity.transition_to(state)