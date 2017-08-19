extends Node

export var inner_grid_size = Vector2(10, 12)
export var outside_grid_size = Vector2(1, 1)
export var count_items = Vector2(3, 6)
export var count_enemies = Vector2(2, 2)
export var dimension = Vector2(13, 17)
var __tile_collection
var __grid
onready var __pathfinding = self.get_node('/root/Game/Pathfinding')

class TileCollection:
	var item = {}
	var tile_size

func fetch_tiles(tile_set_filepath, size_node_name):
	self.__tile_collection = TileCollection.new()
	var tile_set = load(tile_set_filepath).instance()
	for node in tile_set.get_children():
		self.__tile_collection.item[node.get_name().to_lower()] = node
	self.__tile_collection.tile_size = tile_set.get_node(size_node_name).get_texture().get_size()

func __add_tile(tile, xy):
	var tile_dup = tile.duplicate(true)
	tile_dup.set_pos(xy * self.__tile_collection.tile_size)
	self.add_child(tile_dup)

func generate_maze():
	var w = int(dimension.x)
	var h = int(dimension.y)
	var map = []
	for y in range(h):
		map.append([])
		for x in range(w):
			map[y].append('#')
	var frontiers = []
	var x = randi() % w
	var y = randi() % h
	var start_x = [1, w-2]
	var start_y = [1, h-2]
	x = start_x[randi() % 2]
	y = start_y[randi() % 2]
	frontiers.append([x, y, x, y])
	while not frontiers.empty():
		var next = randi() % frontiers.size()
		var f = frontiers[next]
		frontiers.remove(next)
		var x = f[2]
		var y = f[3]
		if map[y][x] == '#':
			map[y][x] = '.'
			map[f[1]][f[0]] = '.'
			if x >= 2 and map[y][x-2] == '#':
				frontiers.append([x-1,y,x-2,y])
			if y >= 2 and map[y-2][x] == '#':
				frontiers.append([x,y-1,x,y-2])
			if x < w-2 and map[y][x+2] == '#':
				frontiers.append([x+1,y,x+2,y])
			if y < h-2 and map[y+2][x] == '#':
				frontiers.append([x,y+1,x,y+2])
	return map

func make_board(map, dim):
	__pathfinding.load_nodes(map)
	var tile = __tile_collection.item.floors
	var enemies_xy = find_freely_connected(map, dim)
	for y in range(dim.y):
		for x in range(dim.x):
			if map[y][x] == '#':
				tile = __rand_tile(__tile_collection.item.walls)
				__add_tile(tile, Vector2(x, y))
			elif map[y][x] == '.':
				tile = __rand_tile(__tile_collection.item.floors)
				__add_tile(tile, Vector2(x, y))
				if randf() < 0.3:
					__add_tile(__rand_tile(__tile_collection.item.items), Vector2(x, y))
#			if map[y][x] == '.':
#				if randf() < 0.05:
#					__add_tile(__rand_tile(__tile_collection.item.enemies), Vector2(x, y))
	var total_ene = 0
	var scores = 0
	var target = false
	while total_ene <= Progress.param.min_ene:
		for enemy_xy in enemies_xy:
			if randf() < 0.5 and total_ene <= Progress.param.max_ene:
				total_ene += 1
				var adj = __pathfinding.adjacent(enemy_xy, map, dim)
				var i = randi() % adj.size()
				var start = adj[i]
				adj.remove(i)
				var next_1 = adj[(i + randi()) % adj.size()]
				var next_2 = []
				var previous = []
				for adj_1 in __pathfinding.adjacent(start, map, dim):
					if adj_1 != enemy_xy:
						previous.append(adj_1)
				for adj_1 in __pathfinding.adjacent(next_1, map, dim):
					if adj_1 != enemy_xy:
						next_2.append(adj_1)
				i = randi() % next_2.size()
				var goal = next_2[i]
				i = randi() % previous.size()
				var start = previous[i]
				var enemy
				if randi() % 3 >= 1 and not target:
					target = true
					__add_tile(__rand_tile(__tile_collection.item.target), start)
					Progress.target = get_tree().get_nodes_in_group('enemy').back()
				else:
					__add_tile(__rand_tile(__tile_collection.item.enemies), start)
				
				enemy = get_tree().get_nodes_in_group('enemy').back()
		#		print(__pathfinding.search(map, start, goal))
				enemy.path = __pathfinding.search(map, start, goal)
				for path in enemy.path:
					enemy.path_2.append(path)
				enemy.path_2.invert()
	var player_xy
	if not Globals.has('player_xy'):
		Globals.set('player_xy', Vector2(1, 1))
	player_xy = Globals.get('player_xy')
	self.__add_tile(self.__tile_collection.item.player, player_xy)

func __rand_tile(tile_set):
	var tiles = tile_set.get_children()
	var r = randi() % tiles.size()
	return tiles[r]

func find_freely_connected(map, dim):
	var nodes = []
	for y in range(dim.y):
		for x in range(dim.x):
			if map[y][x] == '.':
				var num = __pathfinding.adjacent(Vector2(x, y), map, dim).size()
				if num > 2:
					nodes.append(Vector2(x, y))
	return nodes

func _ready():
	pass