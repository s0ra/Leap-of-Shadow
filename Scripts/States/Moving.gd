extends 'State.gd'

#var duration = 0.1
#var __time_elapsed = 0
#var __pos_start
#var delta_xy
#var path = []
#var s_id = 0
onready var __board = self.get_node('/root/Game/Board')
onready var __game = self.get_node('/root/Game')

func enter(entity):
	entity.set_process_input(false)
	entity.set_fixed_process(true)
	entity.__time_elapsed = 0
	entity.__pos_start = entity.get_pos()
	entity.pos = entity.__pos_start
	if not entity.path.empty():
		entity.delta_xy = entity.path[1] - entity.path[0]
		entity.back = entity.delta_xy
#	if entity.is_in_group('enemy'):
#		print('hi')
#		if entity.ray_casts[entity.back].collider().is_in_group('shadow'):
#			var state_name = 'DisappearEnemies'
#			entity.transition_to(self.__parent.get_node(state_name))
#	if entity.is_in_group('shadow'):
	if entity.ray_casts[entity.delta_xy].is_colliding():
		var state_name
		if entity.is_in_group('shadow'):
			var back = entity.ray_casts[entity.delta_xy].get_collider().get_parent().back
#			if entity.hit_success:
			if back == entity.delta_xy:
				state_name = 'DisappearEnemies'
				var state = self.__parent.get_node(state_name)
				entity.ray_casts[entity.delta_xy].get_collider().get_parent().transition_to(state)
				state_name = 'DisappearShadow'
				entity.pos = entity.get_pos()
				state = self.__parent.get_node(state_name)
				state.pos = entity.pos
				entity.transition_to(state)
			else:
				state_name = 'DisappearShadow'
				entity.pos = entity.get_pos()
				entity.teleport = false
				var state = self.__parent.get_node(state_name)
				state.pos = entity.pos
				entity.transition_to(state)
		elif entity.is_in_group('player'):
			state_name = 'IdlePlayer'
			entity.transition_to(self.__parent.get_node(state_name))

func update(entity, delta_time):
	if not entity.path.empty():
		entity.delta_xy = entity.path[1] - entity.path[0]
	if entity.ray_casts[entity.delta_xy].is_colliding():
		var state_name
		if entity.is_in_group('shadow'):
			entity.teleport = false
			state_name = 'DisappearShadow'
	var delta_xy_px = entity.delta_xy * self.__board.__tile_collection.tile_size
	var pos = entity.__pos_start.linear_interpolate(entity.__pos_start + delta_xy_px, entity.__time_elapsed/entity.duration)
	if entity.__time_elapsed >= entity.duration:
		if not entity.path.empty():
			entity.delta_xy = entity.path[1] - entity.path[0]
			entity.path.pop_front();
			if entity.path.size() == 1:
				entity.path.pop_front();
		pos = entity.__pos_start + delta_xy_px
		entity.set_pos(pos)
		var state_name
		if not entity.path.empty():
			state_name = 'Moving'
		elif entity.is_in_group('shadow'):
			state_name = 'DisappearShadow'
			var state = self.__parent.get_node(state_name)
			state.pos = entity.get_pos()
			entity.transition_to(state)
		elif entity.is_in_group('enemy'):
			state_name = 'IdleEnemy'
		elif entity.is_in_group('player'):
			state_name = 'IdlePlayer'
		entity.transition_to(self.__parent.get_node(state_name))
	entity.__time_elapsed += delta_time
	entity.set_pos(pos)