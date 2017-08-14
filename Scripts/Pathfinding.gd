extends Node

var LEFT = Vector2(1, 0)
var RIGHT = Vector2(-1, 0)
var UP = Vector2(0, 1)
var DOWN = Vector2(0, -1)
var road = '.'
var wall = '#'
var as = AStar.new()
var __width = 13
var __height = 17

func search(nodes, start, goal):
	__width = 13
	__height = 17
	var result = as.get_id_path(start.y*__width+start.x, goal.y*__width+goal.x)
	var path = []
	for i in range(result.size()):
		path.append(Vector2(result[i] % __width, int(result[i] / __width)))
	return path

func load_nodes(nodes):
	__width = nodes[0].size()
	__height = nodes.size()
	as.add_point(1*__width+1, Vector3(1, 1, 0))
	for y in range(__height):
		for x in range(__width):
			if nodes[y][x] == road:
				as.add_point(y*__width+x, Vector3(x, y, 0))
	for y in range(__height):
		for x in range(__width):
			if nodes[y][x] == road:
				var adj = adjacent(Vector2(x, y), nodes, Vector2(__width, __height))
				for node in adj:
					if not as.are_points_connected(y*__width+x, node.y*__width+node.x):
						as.connect_points(y*__width+x, node.y*__width+node.x)

func adjacent(node, graph, dim, empty=false):
	var nodes = []
	var xy = Vector2(dim.x, dim.y)
	if bound(node + self.LEFT, xy):
		var x = (node + self.LEFT).x
		var y = (node + self.LEFT).y
		if graph[y][x] == road or empty:
			nodes.append(node + self.LEFT)
	if bound(node + self.RIGHT, xy):
		var x = (node + self.RIGHT).x
		var y = (node + self.RIGHT).y
		if graph[y][x] == road or empty:
			nodes.append(node + self.RIGHT)
	if bound(node + self.UP, xy):
		var x = (node + self.UP).x
		var y = (node + self.UP).y
		if graph[y][x] == road or empty:
			nodes.append(node + self.UP)
	if bound(node + self.DOWN , xy):
		var x = (node + self.DOWN).x
		var y = (node + self.DOWN).y
		if graph[y][x] == road or empty:
			nodes.append(node + self.DOWN)
	return nodes

func bound(xy, size):
	return xy.x < size.x and xy.y < size.y and xy.x >= 0 and xy.y >= 0