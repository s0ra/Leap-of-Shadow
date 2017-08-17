extends 'State.gd'

onready var __game = get_node('/root/Game')
onready var __board = get_node('/root/Game/Board')
onready var timer = Timer.new()

func enter(entity):
	entity.time = randf() * 2
	entity.set_process_input(true)
	entity.set_fixed_process(true)

func update(entity, delta_time):
	entity.time -= delta_time
	if entity.time < 0:
		var state = self.__parent.get_node('IdleEnemies')
		entity.transition_to(state)