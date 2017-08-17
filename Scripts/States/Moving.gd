extends 'State.gd'

#var duration = 0.1
#var __time_elapsed = 0
#var __pos_start
#var delta_xy
#var path = []
#var s_id = 0
const EPSILON = 1e-8
onready var __board = self.get_node('/root/Game/Board')
onready var __game = self.get_node('/root/Game')
onready var __pathfinding = get_node('/root/Game/Pathfinding')

func enter(entity):
	entity.set_process_input(false)
	entity.set_fixed_process(true)
	entity.__time_elapsed = 0
	entity.__pos_start = entity.get_pos()
	entity.pos = entity.__pos_start
	if entity.path.size() > 1:
		entity.delta_xy = entity.path[1] - entity.path[0]
		if entity.is_in_group('enemy'):
			if entity.delta_xy == Vector2(0, 1):
				entity.play('Down')
			elif entity.delta_xy == Vector2(0, -1):
				entity.play('Up')
			elif entity.delta_xy == Vector2(1, 0):
				entity.play('Right')
			elif entity.delta_xy == Vector2(-1, 0):
				entity.play('Left')
		entity.back = entity.delta_xy
	else:
		return
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
				entity.teleport = true
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
		elif entity.is_in_group('enemy'):
			if entity.ray_casts[entity.delta_xy].get_collider() != null:
				if entity.ray_casts[entity.delta_xy].get_collider().get_parent().is_in_group('player'):
					state_name = 'IdleEnemies'
					entity.path = []
					entity.path_2 = []
					entity.set_pos(entity.__pos_start)
					entity.transition_to(self.__parent.get_node(state_name))
					var player = get_tree().get_nodes_in_group('player').front()
					state_name = 'DisappearPlayer'
					player.transition_to(self.__parent.get_node(state_name))
					return
					state_name = 'IdleEnemies'
					entity.path = []
					entity.path_2 = []
					var state = self.__parent.get_node(state_name)
					entity.transition_to(state)

func update(entity, delta_time):
	if entity.path.size() > 1:
		entity.delta_xy = entity.path[1] - entity.path[0]
	if entity.ray_casts[entity.delta_xy].is_colliding():
		var state_name
		if entity.is_in_group('shadow'):
			entity.teleport = false
			state_name = 'DisappearShadow'
		elif entity.is_in_group('enemy') and entity.ray_casts[entity.delta_xy].get_collider() != null:
			if entity.ray_casts[entity.delta_xy].get_collider().get_parent().is_in_group('player'):
				state_name = 'IdleEnemies'
				entity.path = []
				entity.path_2 = []
				entity.set_pos(entity.__pos_start)
				entity.transition_to(self.__parent.get_node(state_name))
				var player = get_tree().get_nodes_in_group('player').front()
				state_name = 'DisappearPlayer'
				player.transition_to(self.__parent.get_node(state_name))
				return
	var delta_xy_px = entity.delta_xy * self.__board.__tile_collection.tile_size
	var pos = entity.__pos_start.linear_interpolate(entity.__pos_start + delta_xy_px, entity.__time_elapsed/entity.duration)
	if entity.__time_elapsed >= entity.duration:
		entity.set_offset(Vector2(0, 0))
		if not entity.path.empty():
			entity.delta_xy = entity.path[1] - entity.path[0]
			entity.path.pop_front();
			if entity.path.size() == 1:
				entity.path.pop_front();
		pos = entity.__pos_start + delta_xy_px
		entity.set_pos(pos)
		var state_name
		
		if entity.is_in_group('enemy'):
			var player = get_tree().get_nodes_in_group('player').front()
			if entity.chased == true and entity.path.empty():
				entity.chased = false
				entity.pos = entity.get_pos()
				var adj = __pathfinding.adjacent(__pathfinding.pos_to_xy(entity.pos), __game.map, __board.dimension)
				var i = randi() % adj.size()
				var start = adj[i]
				var goal
				adj.remove(i)
				var next_1 = adj[(i + randi()) % adj.size()]
				var next_2 = []
				var next_3 = []
				var next_4 = []
				for adj_1 in __pathfinding.adjacent(next_1, __game.map, __board.dimension):
					if adj_1 != __pathfinding.pos_to_xy(entity.pos):
						next_2.append(adj_1)
				if not next_2.empty():
					i = randi() % next_2.size()
					next_2 = next_2[i]
				else:
					next_2 = next_1
				goal = next_2
				for adj_1 in __pathfinding.adjacent(goal, __game.map, __board.dimension):
					if adj_1 != next_1:
						next_3.append(adj_1)
				if not next_3.empty():
					i = randi() % next_3.size()
					next_3 = next_3[i]
				else:
					next_3 = next_2
				goal = next_3
				for adj_1 in __pathfinding.adjacent(goal, __game.map, __board.dimension):
					if adj_1 != next_2:
						next_4.append(adj_1)
				if not next_4.empty():
					i = randi() % next_4.size()
					goal = next_4[i]
				else:
					goal = next_3
				entity.path = __pathfinding.search(__game.map, start, goal)
				for path in entity.path:
					entity.path_2.append(path)
				entity.path_2.invert()
				entity.path.pop_front()
				entity.path_2.pop_back()
				state_name = 'Moving'
				entity.transition_to(self.__parent.get_node(state_name))
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
			
		
		if not entity.path.empty():
			state_name = 'Moving'
		elif entity.is_in_group('shadow'):
			state_name = 'DisappearShadow'
			var state = self.__parent.get_node(state_name)
			state.pos = entity.get_pos()
			entity.transition_to(state)
		elif entity.is_in_group('enemy'):
			state_name = 'IdleEnemies'
			for path in entity.path_2:
				entity.path.append(path)
			entity.path_2.invert()
			var state_name = 'IdleEnemies'
			entity.transition_to(self.__parent.get_node(state_name))
		elif entity.is_in_group('player'):
			state_name = 'IdlePlayer'
		entity.transition_to(self.__parent.get_node(state_name))
	entity.__time_elapsed += delta_time
	if entity.is_in_group('enemy'):
		entity.set_offset(pos - entity.get_pos())
	else:
		entity.set_pos(pos)