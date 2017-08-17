extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func enter(entity):
	entity.set_process_input(false)
	entity.set_fixed_process(false)

#func update(entity, delta_time):
#	if entity.get_node('Area2D').is_colliding():
#		var state_name = 'DisappearCoin'
#		var state = self.__parent.get_node(state_name)
#		entity.get_collider().transition_to(state)