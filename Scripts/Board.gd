extends Node

export var inner_grid_size = Vector2(10, 12)
export var outside_grid_size = Vector2(1, 1)
export var count_items = Vector2(3, 6)
export var count_enemies = Vector2(2, 2)
export var dimension = Vector2(13, 17)
var __tile_collection
var __grid

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
	var tile = __tile_collection.item.floors
	for y in range(dim.y):
		for x in range(dim.x):
			if map[y][x] == '#':
				tile = __rand_tile(__tile_collection.item.walls)
			elif map[y][x] == '.':
				tile = __rand_tile(__tile_collection.item.floors)
			__add_tile(tile, Vector2(x, y))
			if map[y][x] == '.':
				if randf() < 0.05:
					__add_tile(__rand_tile(__tile_collection.item.enemies), Vector2(x, y))
	self.__add_tile(self.__tile_collection.item.player, Vector2(1, 1))

func __rand_tile(tile_set):
	var tiles = tile_set.get_children()
	var r = randi() % tiles.size()
	return tiles[r]

func _ready():
	pass
