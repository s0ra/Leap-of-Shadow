extends 'State.gd'

onready var __game = get_node('/root/Game')
onready var __board = get_node('/root/Game/Board')
onready var __pathfinding = get_node('/root/Game/Pathfinding')

func enter(entity):
	entity.set_process_input(true)
	entity.set_fixed_process(true)
	if not entity.path.empty():
#		print(entity.path)
		var state = self.__parent.get_node('Moving')
		entity.transition_to(state)

func update(entity, delta_time):
	if not entity.path.empty():
#		print(entity.path)
		var state = self.__parent.get_node('Moving')
		entity.transition_to(state)
	var player
	if not get_tree().get_nodes_in_group('player').empty():
		player = get_tree().get_nodes_in_group('player').front()
	if player != null:
		var player_pos = player.get_pos()
		var self_pos = entity.get_pos()
		var chase = __pathfinding.see(__game.map, self_pos, player_pos, entity.delta_xy)
		if chase != null:
			entity.path = chase
			entity.path_2 = []
			entity.duration = 0.7
			var state = self.__parent.get_node('Moving')
			entity.transition_to(state)
			entity.chased = true
#		if entity.ray_casts[entity.back].is_colliding():
#			var state_name
#			if entity.is_in_group('enemy'):
#				state_name = 'DisappearEnemies'
#				entity.transition_to(__parent.get_node(state_name))
#	if entity.is_in_group('enemy'):
#		var collide = entity.ray_casts[entity.back].get_collider()
#		if collide != null:
#			if collide.is_in_group('shadow'):
#				var state_name = 'DisappearEnemies'
#				entity.transition_to(self.__parent.get_node(state_name))

func follow_path():
	pass

func new_path():
#	entity.path = __pathfinding.search()
	pass

func search_pattern():