extends 'State.gd'

onready var __game = get_node('/root/Game')
onready var __board = get_node('/root/Game/Board')
onready var __pathfinding = get_node('/root/Game/Pathfinding')
var path = []

func enter(entity):
	__pathfinding.load_nodes(__game.map)
	entity.set_process_input(true)
	entity.set_fixed_process(false)

func input(entity, event):
	var delta_xy
	if event.is_action_pressed('mouse_left'):
		var graph = __game.map
		var e_xy = pos_to_xy(entity.get_pos())
		var m_xy = pos_to_xy(event.pos)
		if graph[m_xy.y][m_xy.x] == '.' and e_xy != m_xy:
			var s_id = get_tree().get_nodes_in_group('shadow').size() % 9 + 1
			path = __pathfinding.search(graph, e_xy, m_xy)
			__board.__add_tile(__board.__tile_collection.item.shadow, e_xy)
			var shadow = get_tree().get_nodes_in_group('shadow')
			shadow = shadow.back()
			var state_shadow = self.__parent.get_node('IdleShadow')
			shadow.path = path
			shadow.transition_to(state_shadow)
			
			var state = self.__parent.get_node('IdlePlayer')
			entity.transition_to(state)
	if event.is_action_pressed('ui_right'):
		delta_xy = entity.UNIT_RIGHT
	elif event.is_action_pressed('ui_down'):
		delta_xy = entity.UNIT_DOWN
	elif event.is_action_pressed('ui_left'):
		delta_xy = entity.UNIT_LEFT
	elif event.is_action_pressed('ui_up'):
		delta_xy = entity.UNIT_UP

func pos_to_xy(pos):
	var xy = Vector2(int(pos.x / 32), int(pos.y / 32))
	return xy

func update(entity, delta_time):
	if not path.empty():
		var state = self.__parent.get_node('Moving')
#		state.delta_xy = Vector2(path[1].x - path[0].x, path[1].y - path[0].y)
		state.path = path
		path.pop_front()
		if path.size() == 1:
			path.pop_front()
		entity.transition_to(state)
	